#!/bin/sh
PACKER_DIR=`pwd`/$0/..

packer build \
    -var 'aws_access_key=AKIAJDBQ6YZYUQNFIIXA' \
    -var 'aws_secret_key=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' \
    ${PACKER_DIR}/redhat-72-us-east-1.json
