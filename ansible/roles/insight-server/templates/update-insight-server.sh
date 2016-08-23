#!/usr/bin/env bash

# We need to make sure we don't get our latest package from yum cache.
sudo yum clean all
sudo yum install -y palette-insight-server

sudo supervisorctl restart palette-insight-server

sudo service nginx restart
