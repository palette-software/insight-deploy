#!/bin/bash
##############################################
#Execute greenplum_path.sh so we have the gpfidst in the path
#
INSTALL_PATH=/opt/palette-insight-loadtables
. /usr/local/greenplum-db/greenplum_path.sh
# Start gpfidst in background
cd /data/insight-server/uploads/{{ cluster_name }}/processing
gpfdist -p 18001 -l gpfdist.log -v -m 268435456 &
