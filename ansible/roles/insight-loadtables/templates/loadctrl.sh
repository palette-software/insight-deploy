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
    maintenance_after=1030

	#Check if current time has passed the maintenece time and there has been NO maintenance in that day yet.
    if [ $(date -d "$currtime" +"%H%M") -gt $maintenance_after -a $(date -d "$currtime" +"%Y%m%d") -gt $(date -d "$last_maintenance_ts" +"%Y%m%d") ]
    then
        echo Last maintenance run was at $(date -d "$last_maintenance_ts" +"%Y.%m.%d. %H:%M:%S") >> $LOGFILE
        echo Start maintenance... $(date) >> $LOGFILE
        sudo -u gpadmin /home/gpadmin/db_maintenance.sh
        echo End maintenance $(date) >> $LOGFILE
        date -d "$currtime" +"%Y%m%d %H:%M:%S" > last_maintenance_ts
    else
        echo Start reporting... $(date) >> $LOGFILE
        /opt/palette-insight-talend/run_reporting.sh
        echo End reporting $(date) >> $LOGFILE		
    fi
) 200>${LOCKFILE}
