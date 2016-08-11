#!/bin/bash

LOCKFILE=/tmp/PI_LoadCTRL.flock
LOGFILE="./loadctrl.log"

set -e

(
    flock -n 200

    if [ ! -e last_maintenance_ts ]
    then
        echo 10010101 00:00:01 > last_maintenance_ts
    fi

    last_maintenance_ts=$(cat last_maintenance_ts)
    currtime=$(date)
    maintenance_after=0030

    if [ $(date -d "$currtime" +"%H%M") -gt $maintenance_after -a $(date -d "$currtime" +"%Y%m%d") -gt $(date -d "$last_maintenance_ts" +"%Y%m%d") ]
    then
        echo Last maintenance run was at $(date -d "$last_maintenance_ts" +"%Y.%m.%d. %H:%M:%S") >> $LOGFILE
        echo Running maintenance... $(date) >> $LOGFILE
        sudo -u gpadmin /home/gpadmin/db_maintenance.sh
        echo Maintenance successful $(date) >> $LOGFILE
        date -d "$currtime" +"%Y%m%d %H:%M:%S" > last_maintenance_ts
    else
        echo Running reporting... $(date) >> $LOGFILE
        sudo -u insight /opt/palette-insight-talend/run_reporting.sh
        echo Reporting successful $(date) >> $LOGFILE
    fi
) 200>${LOCKFILE}
