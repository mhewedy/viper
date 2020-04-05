# vm
### The smart Virtual Machines manager
Group of scripts/programs to help manage VirtualBox vms - for Mac and Linux

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
      cp        Copy files from host to a VM
```

### Create a new VM
Use the following command to create a VM

```
$ vm create <image name>
# example
$ vm create ubuntu/bionic
```
Or in case you want to create and provision the VM: (see [samples folder](https://github.com/mhewedy/vm/tree/master/samples/provision) for sample provision scripts)
```
$ vm create <image name> /path/to/provison.sh 
# example
$ vm create ubuntu/bionic ~/init.sh
```

> Note: To get list of all local available images use `vm images`

> Note: You will need to create one or more images first, see [How to create an image](#how-to-create-an-image).

### List all created VMs
This subcommand list all VMs (stopped and running)
```
$ vm ls
VM NAME		IMAGE			CPU		MEM		TAGS
vm_01		ubuntu/bionic		1		1024 MB		spark kafka
vm_02		ubuntu/bionic		1		1024 MB
```

### List all running VMs
```
$ vm ps
VM NAME		IMAGE			CPU		MEM		TAGS
vm_01		ubuntu/bionic		1		1024 MB		spark kafka
```


### ssh into a VM
```
$ vm ssh vm_03
```

### Start one or more VM
```
$ vm start vm_01 vm_02
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

## How to create an image:

**The following steps need to do done once for each image you want to create:**

1. [Install Linux on VirtualBox](https://www.wikihow.com/Install-Ubuntu-on-VirtualBox)
2. [Change network settings to *Bridge*](https://www.opentechguides.com/how-to/article/virtualbox/140/vm-virtualbox-networking.html)
3. Login to the guest os then run the script [post_create_deb.sh](https://raw.githubusercontent.com/mhewedy/vm/master/samples/post_create_deb.sh) to do required setup. *(you will have to slightly modify it to run on non-debian distro)*
4. [Export the VM as *OVA*](https://www.maketecheasier.com/import-export-ova-files-in-virtualbox/)
5. Move the exported image under `$HOME/.vms/boxes/<distro name>/<distro version>.ova`, for example in case of ubuntu 18.04, move the exported ova file to `$HOME/.vms/boxes/ubuntu/bionic.ova`

## Why not Vagrant:

* **Vagrant** uses a `Vagrantfile` which I think is most suited to be source-controlled, and for my case it is an overhead to maintain such file for each vm I want to create. (like create k8s cluster, etc...), I want kind of global accessibility.
