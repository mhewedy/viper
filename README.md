# vm
VirtaulBox manager wrapper

Group of scripts/programs to help manage virtaulbox vms

  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
  * [Usage](#usage)
  * [Why not vagrant](#why-not-vagrant)

## Prerequisites
* [VirtualBox ](https://www.virtualbox.org/wiki/Downloads)
* [Golang compiler](https://golang.org/dl/)
* [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) - Not a requirement, however the autocomplete will only works for zsh.

> golang compiler needed to create `vmip` executable, which is used to find the IP address of particular VM. (used by the vm script)

## Installation
> Make sure that "$HOME"/bin is on your path, otherwise modify your `.zshrc` or `.bashrc` file to add it.

Download or clone the repository and run `./build.sh`

## Usage:

### Create a new VM
You need to have an **ova** file already created, see this [post](https://www.maketecheasier.com/import-export-ova-files-in-virtualbox/) to know how to export your vm as ova in virtual box.

Usually first, you need to create a new VM the regular way using Virtual Box only once and customize it according to your own needs.(e.g. edit the `/etc/sources.list` to point to some apt-cahcer server, customize the `PS1` variable to contains the ip addr of the machine, etc...)
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

## Why not Vagrant:

Vagrant is greate, but I wanted very simple script to control my local VMs.
Vagrant is very powerful in provisioning part, but mostly I don't need such feature, and I don't want to mantain such VagrantFile.
