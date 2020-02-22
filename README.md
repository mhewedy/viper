# vm
VirtualBox manager wrapper

Group of scripts/programs to help manage VirtualBox vms    
Tested on:
 * **macos** (*zsh*)
 * **ubuntu** (*zsh*, *bash*)
----
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
  * [Usage](#usage)
  * [Why not Vagrant](#why-not-vagrant)
  * [FAQs](#faqs)

## Prerequisites
* [VirtualBox ](https://www.virtualbox.org/wiki/Downloads)
* [Golang compiler](https://golang.org/dl/) >= v 1.13
* [zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH) - Not a requirement, however the autocomplete will only works for zsh.

> golang compiler needed to create `vmip` executable, which is used to find the IP address of particular VM. (used by the vm script)

## Installation
Download or clone the repository and run `./build.sh`

## Usage:

### Create a new VM

The following steps need to do **once**:
1. [Install Linux on VirtualBox](https://www.wikihow.com/Install-Ubuntu-on-VirtualBox)
2. [Change network settings to *Bridge*](https://www.opentechguides.com/how-to/article/virtualbox/140/vm-virtualbox-networking.html)
3. *Optional* - You may need to login to the VM and do some customizations (customzie `PS1` to contains the IP of the VM, e.g. `PS1="\[\e[1;35m\]\u\[\033[m\]@\h-\[\e[1;92m\]$(hostname -I | awk '{print $1}')\[\033[m\]:\w \$ "` or execte `ssh-copy-id` command on host in order to use certificate authentication instead of password authentication)
4. [Export the VM as *OVA*](https://www.maketecheasier.com/import-export-ova-files-in-virtualbox/)

Then each time you need to create a new VM execute the following command:
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
> This assumes that, there's a user with name `mhewedy` already created in the operation system (Linux 😉) installed on the VM

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
Vagrant is very powerful in provisioning part, but mostly I don't need such feature, moreover I don't want to mantain such `VagrantFile` and I see the concept of local vs global boxes is not suited to my case.

## FAQs
* `ssh: connect to host 192.168.1.26 port 22: Operation timed out.`        
 This is usually because the VM ip address has been changed, use `vmip <vm-name> --purge` then `vm ssh <vm-name>`
