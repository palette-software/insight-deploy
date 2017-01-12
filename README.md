# Palette Insight Deployment

[Ansible Playbook]:    http://docs.ansible.com/ansible/playbooks.html
[Palette Insight]:     https://github.com/palette-software/palette-insight
[Greenplum Database]:  http://greenplum.org
[Greenplum Installer]: https://github.com/palette-software/greenplum-installer

## What is Palette Insight Deployment?

This repository contains various [Ansible Playbook]s and roles to provision
machines for running the [Palette Insight] software or a [Greenplum Database]
instance.

## Inventory files

The [Ansible Inventory](http://docs.ansible.com/ansible/intro_inventory.html)
files can be used to apply the same [Ansible Playbook] to multiple machines at once.

An example:

```ini
[early-adopter]
HOST_NAME  splunk_host=HOST_NAME_FOR_SPLUNK

[early-adopter:vars]
channel: early_adopter

[insight-server:children]
early-adopter
```

## Creating EC2 instances

The role `ec2-create` and `ec2-users` can handle the creation of new
machines for insight-servers (or other purposes).

The variables used by these [playbook](ansible/ec2-provision.yml):

```yaml
# The Amazon VPC to use (the roles do not create it)
vpc:
  # The VPC ID:
  # vpc-88e89aec (10.4.0.0/24) | Palette Insight US East 1 (v2)
  # vpc-8ba59dee (172.16.0.0/16) | Amazon
  id: vpc-8ba59dee

  # The subnet ID:
  # subnet-ad10e787 (172.31.2.0/24) | Redshift US East Subnet
  # subnet-d33f7ff8 (172.16.2.0/24) | Amazon
  subnet_id: subnet-d33f7ff8

# The project_name is used to name security groups and keys
project_name: "insight-ebs-migrate"

# env name, this will be used as an inventory file name
env: "staging"

# remote user to add keys to
app_code_user: "{{ uservar }}"

# The AWS region for the instance
aws_region: us-east-1 # AWS region, where instance will be created

# AWS instance type
instance_type: t2.micro

# Centos 6.5 w. updates / HVM / US-East
ami: ami-1c221e76
```

## Greenplum Shell

The [greenplum-shell.yml](ansible/greenplum-shell.yml) playbook can provision
a machine before the [Greenplum Installer] could be used to install a
[Greenplum Database] instance.

```bash
ansible-playbook greenplum-shell.yml -i <INVENTORY> --private-key <PRIVATE_KEY_FILE>
```

## Creating Greenplum Metal RPMs

**NOTE**: This method is *superseded* by the [Greenplum Installer].

This can be used to package the [Greenplum Database] binaries and
so ease the installation.

On a linux box with rpm-build installed:

```bash
cd rpm/greenplum
./build.sh /tmp/greenplum-install-4.3.7.3 4.3.7.3
```

## Installing the insight-server base (without greenplum) on a machine

**NOTE**: This method is *superseded* by the [Platte Insight] installer.

```bash
ansible-playbook insight-server.yml -i <INVENTORY> --private-key <PRIVATE_KEY_FILE> --extra-vars "uservar=<SSH_USERNAME_FOR_KEY> --vault-password-file <VAULT_PASSWORD_FILE>"
```

The <VAULT_PASSWORD_FILE> is just a text file, which only contains the password for the Ansible Vault.

For example to install on a list of EC2 hosts stored in aws-hosts.ini:

```bash
ansible-playbook insight-server.yml -i ./aws-hosts.ini --private-key ~/.ssh/palette-insight-standard-keypair-2016-01-19.pem.txt -v --extra-vars "uservar=ec2-user --vault-password-file ~/.ansible_vault_pass.txt"
```

## Installing greenplum on a machine

**NOTE**: This method is *superseded* by the [Greenplum Installer].

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

## Is Palette Insight Deployment supported?

Palette Insight Deployment is licensed under the GNU GPLv3 license. For professional support please contact developers@palette-software.com

**TODO: Clarify support part!**

Any bugs discovered should be filed in the [Palette Insight Deployment Git issue tracker](https://github.com/palette-software/insight-deploy/issues) or contribution is more than welcome.
