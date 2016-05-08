#!/bin/sh

## RHEL/CentOS 6 64-Bit ##

sudo yum install wget python -y

# Add the EPEL repo
wget --no-check-certificate http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -ivh epel-release-6-8.noarch.rpm

# replace https with http in /etc/yum.repos.d/epel.repo
sudo perl -i -pe 's/https/http/g' /etc/yum.repos.d/epel.repo

# install ansible
sudo yum install ansible -y


# Copy the deployment key over
cp /provisioning/vagrant/keys/insight-deploy-key /home/vagrant/.ssh/insight-deploy-key
chmod 600 /home/vagrant/.ssh/insight-deploy-key
