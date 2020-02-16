# vm
VirtaulBox manager wrapper

a group of scripts/programs to help manage virtaulbox vms

## Prerequisites
* [VirtualBox ](https://www.virtualbox.org/wiki/Downloads)
* [Golang compiler](https://golang.org/dl/)
* [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) - Not a requirement, however the autocomplete will only works for zsh.

> golang compiler needed to create `vmip` executable, which is used to find the IP address of particular VM. (used by the vm script)

## Installation
> Make sure that "$HOME"/bin is on your path, otherwise modify your `.zshrc` or `.bashrc` file.

> The autocompletion only works if **zsh** is the default shell.

Download the repository and run `./build.sh`

## Usage:

### Create a new VM
You need to have an **ova** file already created, see this [post](https://www.maketecheasier.com/import-export-ova-files-in-virtualbox/) to know how to export your vm as ova in virtual box.

Usually first, you need to create a new VM the regular way using Virtual Box only once and customize it according to your own needs.
Then export this VM as an **ova** file - as in the link above - and then use this ova file in the create command:

```
$ vm create /path/to/exported.ova
```

### List all created VMs
This subcommand list all created VMs (stopped and running)
```
$ vm ls
vm_01
vm_02
```

### List all running VMs
This subcommand list all running VMs

```
$ vm ps
vm_01
```

### Start one or more VMs

```
$ vm start vm_01 vm_02
```


### ssh into a VM
> This assumes that, there's a user with name `mhewedy` already created in the operation system installed on the VM

```
$ vm ssh vm_03
```

### Stop one or more VMs

```
$ vm stop vm_03
```

### Remove one or more VMs
```
$ vm rm vm_03
```
