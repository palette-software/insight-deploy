#/usr/bin/env bash
set -x

# build base centos
packer build packer/insight-server-centos-68-base.json

# create empty data disk image
mkdir -p output-insight-server-centos-68-data
if [ -f output-insight-server-centos-68-data/insight-server-centos-68-data ];
then rm output-insight-server-centos-68-data/insight-server-centos-68-data; fi
qemu-img create output-insight-server-centos-68-data/insight-server-centos-68-data -o size=1T

# build provisioned insight-server
packer build packer/insight-server-centos-68-provision.json
