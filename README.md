# Palette Insight Deployment


## Invatory files

An example inventory file:

```ini
[early-adopter]
HOST_NAME  splunk_host=HOST_NAME_FOR_SPLUNK

[early-adopter:vars]
channel: early_adopter


[insight-server:children]
early-adopter

```

## Creating Greenplum Metal RPMs

On a linux box with rpm-build installed:

```bash
cd rpm/greenplum
./build.sh /tmp/greenplum-install-4.3.7.3 4.3.7.3
```


## Installing the insight-server base (without greenplum) on a machine:

```bash
ansible-playbook insight-server.yml -i <INVENTORY> --private-key <PRIVATE_KEY_FILE> --extra-vars "uservar=<SSH_USERNAME_FOR_KEY>"
```


For example to install on a list of EC2 hosts stored in aws-hosts.ini:

```bash
ansible-playbook insight-server.yml -i ./aws-hosts.ini --private-key ~/.ssh/palette-insight-standard-keypair-2016-01-19.pem.txt -v --extra-vars "uservar=ec2-user"
```


## Installing greenplum on a machine:

After the basic insight-server tools are installed, ansible can be used
to install greenplum and set up the single node cluster:

```bash
ansible-playbook greenplum.yml -i <INVENTORY> --private-key <PRIVATE_KEY_FILE> --extra-vars "uservar=<SSH_USERNAME_FOR_KEY>"
```

For example to install on a list of EC2 hosts stored in aws-hosts.ini:

```bash
ansible-playbook greenplum.yml -i ./aws-hosts.ini --private-key ~/.ssh/palette-insight-standard-keypair-2016-01-19.pem.txt -v --extra-vars "uservar=ec2-user"
```

This playbook:
- installs the python packages necessary for greenplum
- updates sysctl with the requirements for greenplum (semaphores, page
  sizes)
- adds a new limits config file to ```limits.d```
- installs the greenplum-metal RPM package (that is generated from the
  pivotal greenplum installer)
- creates the gpadmin user
- creates the ```/data/master``` and ```/data/primary``` folders
- sets up the path for the gpadmin user and the database path (and adds
  it to ```.bashrc```
- configures the ```/etc/gphosts``` file with only the local machine
  present
- runs ```gpssh-exkeys``` to exchange keys
- runs ```gpinitsystem``` with a single-node setup
- creates the palette database
- allows local connections for all users
- allows remote connections via MD5
- tunes the database
