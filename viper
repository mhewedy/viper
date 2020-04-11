#! /bin/bash

# this script is more towards when the network settings is bridge,
# however I think it works in other settings as well.

# default user and password to the vm
vmuser="viper"
vmbasedir="$HOME/.viper"

# --- start of util functions

# $1 is the vm name
getvmip() {
  vmname=$1
  vmip "$vmname" # see vmip subdirectory
  while [ $? -ne 0 ]; do
    sleep 5
    vmip "$vmname"
  done
}

# make sure connection to vm is established and valid ip is retruned
establish_ssh() {
  vmname=$1
  # try first the nice way that waits until ip is assigned
  ip=$(getvmip "$vmname")
  ssh -i "$vmbasedir/viper_rsa" "$vmuser@$ip" -- ls &>/dev/null
  while [ $? -ne 0 ]; do
    # try the hard way if the assigned ip is invalid
    ip=$(vmip "$vmname" --purge)
    ssh -i "$vmbasedir/viper_rsa" "$vmuser@$ip" -- ls &>/dev/null
  done
}

# -- start of case functions
create_fn() {
  next=$(($(vboxmanage list vms | sort | tail -n 1 | cut -d " " -f1 | cut -d "\"" -f2 | cut -d "_" -f2) + 1))
  vmname="vm_$(printf %02d $next)"
  imagename=$2

  mkdir -p "$vmbasedir"
  vboxmanage import "$vmbasedir/boxes/${imagename}.ova" --vsys 0 --vmname "$vmname" --basefolder "$vmbasedir" --cpus 1 --memory 1024 >>"$vmbasedir/log.out"
  echo "vm created: $vmname"
  echo "$imagename" >>"$vmbasedir/$vmname/image"

  if [ "$#" -gt 2 ]; then
    script=$3
    rscript=$(basename "$script")

    echo "provisioning $vmname..."

    vboxmanage startvm "$vmname" --type headless >>"$vmbasedir/log.out"

    establish_ssh "$vmname"
    ip=$(getvmip "$vmname")
    scp -i "$vmbasedir/viper_rsa" "$script" "$vmuser@$ip:/tmp/$rscript" >"$vmbasedir/log.out"
    ssh -i "$vmbasedir/viper_rsa" "$vmuser@$ip" -- chmod +x "/tmp/$rscript"
    ssh -i "$vmbasedir/viper_rsa" "$vmuser@$ip" -- "/tmp/$rscript"
  fi
}

rm_fn() {
  # accept multiple vms names
  for vmname in "${@:2}"; do
    echo "deleting $vmname ..."
    vboxmanage controlvm "$vmname" poweroff
    VBoxManage unregistervm "$vmname" --delete
    rm -rf "$vmbasedir/$vmname"
  done
}

start_fn() {
  # accept multiple vms names
  for vmname in "${@:2}"; do
    echo "starting $vmname ..."
    vboxmanage startvm "$vmname" --type headless
  done
}

stop_fn() {
  # accept multiple vms names
  for vmname in "${@:2}"; do
    echo "stoping $vmname ..."
    vboxmanage controlvm "$vmname" poweroff
  done
}

# ---- start of case statement
case $1 in
ls) # vm ls
  arr=($(vboxmanage list vms | cut -d " " -f1 | cut -d "\"" -f2))
  vminfo "${arr[@]}"
  ;;
ps) # vm ps
  arr=($(vboxmanage list runningvms | cut -d " " -f1 | cut -d "\"" -f2))
  vminfo "${arr[@]}"
  ;;
create)
  if [ $# -lt 2 ]; then
    printf "Usage: viper create <image> [/path/to/provision_script.sh]
\nWhere:
<image> = <distro name>/<distro version>
\nExamples:
$ viper create ubuntu/bionic
\nUse the sub command \"images\" to list all vm images avaiable
"
    exit 2
  fi
  create_fn "$@"
  ;;
rm)
  if [ $# -eq 1 ]; then
    printf "Usage: viper rm <vmname1> [,vmname2, ...]
\nExamples:
$ viper rm vm_01
"
    exit 2
  fi

  rm_fn "$@"
  ;;
start)
  if [ $# -eq 1 ]; then
    printf "Usage: viper start <vmname1> [,vmname2, ...]
\nExamples:
$ viper start vm_01
"
    exit 2
  fi

  start_fn "$@"
  ;;
stop)
  if [ $# -eq 1 ]; then
    printf "Usage: viper stop <vmname1> [,vmname2, ...]
\nExamples:
$ viper stop vm_01
"
    exit 2
  fi

  stop_fn "$@"
  ;;
ssh)
  if [ $# -lt 2 ]; then
    printf "Usage: viper ssh <vmname> [-- remote commands]
\nExamples:
$ viper ssh vm_01
\n$ viper ssh vm_01 -- cat /etc/passwd
"
    exit 2
  fi

  establish_ssh "$2"

  ip=$(getvmip "$2")
  ssh -i "$vmbasedir/viper_rsa" "$vmuser@$ip" "${@:3}"
  ;;
port)
  if [ $# -lt 3 ]; then
    printf "Usage: viper port <vmname> <vm port>[:local port] [<vm port>[:local port]]
\nExamples:
# forward vm port 4040 to local port 4040
$ viper port vm_01 4040
\n# forward vm port 4040 to local port 40040
$ viper port vm_01 4040:40040
\n# forward vm port 4040 to local port 40040 and port 8080 to 8080
$ viper port vm_01 4040:40040 8080
\n# forward vm port 4040 to local port 40040 and ports in range (8080 to 8088) to range(8080 to 8088)
$ viper port vm_01 4040:40040 8080-8088
\n# forward vm port 4040 to local port 40040 and ports in range (8080 to 8088) to range(9080 to 9088)
$ viper port vm_01 4040:40040 8080-8088:9080-9088
"
    exit 2
  fi

  vm_name="$2"
  ip=$(getvmip "$vm_name")
  ports="${*:3}"
  establish_ssh "$vm_name"

  printf "\nConnected. Press CTRL+C anytime to stop\n"
  ssh -i "$vmbasedir/viper_rsa" $(vmports $ports) "$vmuser@$ip" -N
  ;;
cp)

  usage="Usage: viper cp <vmname> [--local-file=<file>|--remote-file=<file>]
\nCopy files between host and VM
\nExamples:

# copy from local host to VM:
# copy file.txt from host to user's home directory inside the vm
$ viper cp vm_01 --local-file=file.txt

# copy from VM to local host:
# copy file.txt from user's home directory inside the vm to the current direcoty on the host
$ viper cp vm_01 --remote-file=~/file.txt
"

  if [ $# -lt 3 ]; then
    printf "$usage"
    exit 2
  fi

  vm_name="$2"
  fileparam="$3"

  if [[ "$fileparam" =~ ^--local-file=* ]]; then

    ip=$(getvmip "$vm_name")
    establish_ssh "$vm_name"

    file=$(echo $fileparam | cut -d '=' -f 2)
    scp -i "$vmbasedir/viper_rsa" $file $vmuser@$ip:/home/$vmuser/$file

  elif [[ "$fileparam" =~ ^--remote-file=* ]]; then

    ip=$(getvmip "$vm_name")
    establish_ssh "$vm_name"

    file=$(echo $fileparam | cut -d '=' -f 2)
    scp -i "$vmbasedir/viper_rsa" $vmuser@$ip:$file .

  else
    printf "$usage"
  fi

  ;;

images)
  img=$(imagelist)
  if [[ -z $img ]]; then
    echo "see https://github.com/mhewedy/viper/blob/master/README.md#how-to-create-an-image for how to create an image"
  else
    echo $img
  fi
  ;;
ip)
  if [ $# -lt 2 ]; then
    printf "Usage: viper ip <vmname> [--purge]
\nExamples:
$ viper ip vm_01
\n#to purge the IP cache:
$ viper ip vm_01 --purge
"
    exit 2
  fi

  vm_name="$2"
  vmip $vm_name "$3"
  ;;
tag) # very basic impl that does not prevent duplicates and without the ability to untag (go modify the file directly when needed)
  if [ $# -lt 3 ]; then
    printf "Usage: viper tag <vmname> <tag>
\nExamples:
$ viper tag vm_01 my_k8s
"
    exit 2
  fi

  vmname="$2"
  tag="$3"
  echo "$tag" >>"$vmbasedir/$vmname/tags"
  ;;
*)
  printf "Usage: viper <command> [options]
Create, control and connect to VirtualBox VM instances.

Available commands:

    Listing:
      ls        List created VMs
      ps        List running VMs
      images    List images
      ip        Show IP address for a running VM

    VM basic:
      create    Create a VM from image
      tag       Create tag for a VM
      start     Start one or more VMs
      stop      Stop one or more VMs
      ssh       ssh into a running VM
      rm        Remove one or more VMs

  Host operations:
      port      Forward port(s) from a VM to host
      cp        Copy files between host and VM
"
  exit 2
  ;;
esac
