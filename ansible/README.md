# Using ansible to update / deploy machines

## Pre-requisites

### Machine requirements:


- Greenplum requires at least 8 Gb of memory
- the OS of choice is CentOS 6 for now (use the Centos 6 with Updates
  HVM amazon image as a starting point)
- Root SSH access must be enabled (```PermitRootLogin yes``` in ```/etc/sshd.conf```) for
  gpssh-exkeys to work
- No ```AllowUsers``` directive in sshd_config (it might hinder the GP
  SSH key exchange)


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


## Creating a new insight-server

### 1. Create a new instance in EC2.

For instance parameters, please refer to a Palette engineer.

### 2. Add the volumes:

- A system volume (GP2) of 10 Gb to /sda
- A data volume (GP2) to /sdb
- A swap volume (GP2)  of 32 Gb to /sdt

### 3. Add the machine to the inventory

If you are using `deploy-eu.palette-software.net` then add it to

```/etc/ansible/hosts```

following this pattern:

```ini
[early-adopter]
bsci-insight.palette-software.net splunk_host=BSCI-PROD
tableau_version=9.2.4
netflix-insight.palette-software.net splunk_host=NETFLIX
tableau_version=9.2.4
isi-qa-insight.palette-software.net splunk_host=ISI-QA
tableau_version=9.3.0
isi-insight.palette-software.net splunk_host=ISI-PROD
tableau_version=9.1.1


[early-adopter:vars]
channel=early_adopter
uservar=centos
insight_datamodel_version=v1.2.3

[dev]
staging-insight.palette-software.net splunk_host=STAGING
tableau_version=9.2.4
dev-insight.palette-software.net splunk_host=DEV tableau_version=9.2.4

[dev:vars]
channel=early_adopter
uservar=centos
insight_datamodel_version=v1.2.3


[insight-server:children]
early-adopter
dev

```

Adding a host means adding a line to the proper section (dev, early
adopter), and specifying the correct values for the deployment:

- ```splunk_host```: the name which will be used in splunk

- ```tableau_version```: the version of tableau the client is using.
  Used for getting the initial metadata for LoadTables when the agent
  has not yet sent any metadata.

- ```hostname_fqdn```: If the hostname you wish to setup differs from
  the
  connection address (f.e. there is no DNS record assigned to the
  machine yet)


After you have setup the ansible inventory, you have to add the host to
the SSH configuration for the key-based-auth.

```bash
vim ~/.ssh/config
```

### 4. Testing if the user can connect

After the host is added, you can test if the host can be connected to:

```bash
ansible all -m ping
```

This should return a nice green OK for all hosts. If you see red errors,
please check your ssh config.


### 5. Running the playbook

If everything is set up (please check the ```data_model_version```
variable), you can run the playbook for all hosts by:

```bash
ansible-playbook insight-server.yml
```

To run the playbook for hosts in a single channel use the ```channel```
extra variable:

```bash
ansible-playbook insight-server.yml --extra-vars "channel=dev"
ansible-playbook insight-server.yml --extra-vars "channel=early-adopter"
```

