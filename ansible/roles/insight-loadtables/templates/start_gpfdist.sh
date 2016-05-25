#!/bin/bash

# Fail if there are errors
set -e

##############################################
#Execute greenplum_path.sh so we have the gpfidst in the path
. {{ greenplum_install_path }}/greenplum_path.sh

# Go to the actual data directory where the files are
cd /data/insight-server/uploads/{{ cluster_name }}/processing

# Start gpfidst in background, but dont log to stdout instead of
# a logfile
gpfdist -p {{ gpfdist_port }} -v -m 268435456
