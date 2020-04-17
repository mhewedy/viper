# viper
### The smart Virtual Machines manager

Create, control and connect to VirtualBox VM instances.   
*tested on mac and linux*
----

## Prerequisites
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Installation
[Download latest release](https://github.com/mhewedy/viper/releases/latest), extract the archive then run `./install.sh`

## Usage:

```bash
Usage: viper <command> [options]
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
```

### Create a new VM
Use the following command to create a VM

```
$ viper create <image name>
# example
$ viper create ubuntu/bionic
```
Or in case you want to create and provision the VM: (see [samples folder](https://github.com/mhewedy/viper/tree/master/samples/provision) for sample provision scripts)
```
$ viper create <image name> /path/to/provison.sh 
# example
$ viper create ubuntu/bionic ~/init.sh
```

To get list of all available images use:
```
$ viper images
ubuntu/bionic	(cached)
centos/8
```
Note, the *cached* flag means, the image has been already downloaded and cached before.

### List all created VMs
This subcommand list all VMs (stopped and running)
```
$ viper ls
VM NAME		IMAGE			CPU		MEM		TAGS
vm_01		ubuntu/bionic		1		1024 MB		spark kafka
vm_02		ubuntu/bionic		1		1024 MB
```

### List all running VMs
```
$ viper ps
VM NAME		IMAGE			CPU		MEM		TAGS
vm_01		ubuntu/bionic		1		1024 MB		spark kafka
```

### Start one or more VM
```
$ viper start vm_01 vm_02
```

### ssh into a VM
```
$ viper ssh vm_03
```

### Stop one or more VMs
```
$ viper stop vm_03
```

### Remove one or more VMs
Will stop and remove listed VMs
```
$ viper rm vm_03
```

### Copy files:
Copy remote file on VM to you local host in the current path:
```
$ viper cp vm_01 --remote-file=/path/to/file/on/vm
```

Copy local file from your host to the VM's home directory:
```
$ viper cp vm_01 --local-file=/path/to/file/on/host
```

### Port forward:
forward ports from VM to local host (all ports from 8080 to 8090):
```
$ viper port vm_01 8080-8090
```

## Why not Vagrant:

* **Vagrant** uses a `Vagrantfile` which I think is most suited to be source-controlled, and for my case it is an overhead to maintain such file for each vm I want to create. (like create k8s cluster, etc...), I want kind of global accessibility.
