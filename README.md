# vm
VirtaulBox manager wrapper

a group of scripts/programs to help manage virtaulbox vms

## Prerequisites
* [VirtualBox ](https://www.virtualbox.org/wiki/Downloads)
* [Golang compiler](https://golang.org/dl/)

> golang compiler needed to create `vmip` executable, which is used to find the IP address of particular VM. (used by the vm script)

## Installation
Download the repository and run `./build.sh`
> Make sure that "$HOME"/bin is on your path, otherwise modify your `.zshrc` or `.bashrc` file.

> The autocompletion only works if **zsh** is the default shell.

## Usage:

### Create a new VM
You need to have an ova file already created, see this [post](https://www.maketecheasier.com/import-export-ova-files-in-virtualbox/) to know how to export your vm as ova in virtual box.
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


### Stop one or more VMs

```
$ vm stop vm_03
```

### ssh into a VM
> This assumes that, there's a user with name `mhewedy` already created in the operation system installed on the VM

```
$ vm ssh vm_03
```

### Remove one or more VMs
```
$ vm rm vm_03
```
