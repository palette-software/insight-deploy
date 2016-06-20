# Pre-requisites

### Machine requirements:


- Greenplum requires at least 8 Gb of memory
- the OS of choice is CentOS 6 for now (use the Centos 6 with Updates
  HVM amazon image as a starting point)


### Disk requirements:

- a main system volume attached to ```/dev/xvda1```
- a data volume attached ```to /dev/xvdb``` (b for big)
- a swap volme (the same size as the memory of the machine) attached to ```/dev/xvdt``` (t for temp)


### Prepare ansible SSH pipelinening

When starting from a centos image, by default sudo is only allowed for
connections with a tty. For pipelinening to work, you have to replace
the line in ```/etc/sudoers```:

```
Defaults    requiretty
```

with

```
Defaults    !requiretty
```

# Running the playbook

```
ansible-playbook -i aws-hosts2.ini insight-server.yml
```

If you would like to manually provide versions or override other configuration options, you can do it with the ```-a``` command line switch:

```
ansible-playbook -i aws-hosts2.ini insight-server.yml -a "insight_datamodel_version=v1.3.1"
```
