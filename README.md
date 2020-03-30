# vm
Simple VirtualBox manager wrapper (Group of scripts/programs to help manage VirtualBox vms - for Mac and Linux)

----

## Prerequisites
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Installation
[Download latest release](https://github.com/mhewedy/vm/releases/latest), extract the archive then run `./install.sh`

## Usage:

```bash
Usage: vm <command> [options]
Create, control and connect to VirtualBox VM instances.

Available commands:
  ls        List all created VMs
  ps        List all running VMs
  create    Create a VM from OVA file
  rm        Remove one or more VMs
  start     Start one or more VMs
  stop      Stop one or more VMs
  ssh       ssh into a running VM
  forward   Forward port from VM to host
  cp        Copy files from host to VM

```

### Create a new VM

The following steps need to do **once**:
1. [Install Linux on VirtualBox](https://www.wikihow.com/Install-Ubuntu-on-VirtualBox) (make sure to have a user named `vm_user` with any password of choice)
2. [Change network settings to *Bridge*](https://www.opentechguides.com/how-to/article/virtualbox/140/vm-virtualbox-networking.html)
3. Install ssh server on the guest os (e.g. `openssh-server`) 
4. *Optional* - You may need to login to the VM and do some actions such as:
   1. Execute the command`visudo` and add `vm_user ALL=(ALL) NOPASSWD:ALL` to allow execute sudo commands without providing password (required for provisioner to work)
   2. Copy the content of [vm_rsa.pub](https://raw.githubusercontent.com/mhewedy/vm/master/keys/vm_rsa.pub) to the VM as the file `$HOME/.ssh/authorized_keys`
5. [Export the VM as *OVA*](https://www.maketecheasier.com/import-export-ova-files-in-virtualbox/)
6. Move the exported image under `$HOME/.vms/boxes/<distro name>/<distro version>.ova`, 
for example in case of ubuntu 18.04, move the exported ova file to `$HOME/.vms/boxes/ubuntu/bionic.ova`

*Then each time you need to create a new VM execute the following command:*
```
$ vm create <distro name>/<distro version>
# example
$ vm create ubuntu/bionic
```
Or in case of provisioner (see samples folder for sample provision scripts)
```
$ vm create <distro name>/<distro version> /path/to/provison.sh 
# example
$ vm create ubuntu/bionic ~/init.sh
```

> Note: To get list of all local available images use `imagelist`

### List all created VMs
This subcommand list all created VMs (stopped and running)
```
$ vm ls
vm_01
vm_02
```

### List all running VMs
```
$ vm ps
vm_01
```

### Start one or more VMs
```
$ vm start vm_01 vm_02
```

### ssh into a VM
```
$ vm ssh vm_03
```

### Stop one or more VMs
```
$ vm stop vm_03
```

### Remove one or more VMs
Will stop and remove listed VMs
```
$ vm rm vm_03
```

## Why not Vagrant:

* Vagrant uses a Vagrantfile which I think is most suitated to be source-controlled, and for my case it is an overhead to maintain such file for each vm I want to create. (like create k8s cluster, etc...), I want kind of global accessibility.
