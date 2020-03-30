# Proposal to manage VMs on Remote hosts


## Read operations:

* Before:
```
$ vm ls
vm_name
```

* After
```
$ vm ls
host/vm_name
```

## Create:
* Before

```
Usage: vm create <image> [/path/to/provision_script.sh]
```
* After

```
Usage: vm create <image> [/path/to/provision_script.sh] [--host=<host>]
```

## Control Operations:

* Before

```
$ vm start vm_name
```
```
$ vm stop vm_name
```
```
$ vm ssh vm_name [options]
```

* After

```
$ vm start [host/]vm_name
```
```
$ vm stop [host/]vm_name
```
```
$ vm ssh [host/]vm_name [options]
```
