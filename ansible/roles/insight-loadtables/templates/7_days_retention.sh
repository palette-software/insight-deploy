#!/bin/bash

DBNAME="palette"
SCHEMA="palette"
LOGFILE="./kgz_7days_ret.log"


echo "Start drop old partitions. " + $(date) >> $LOGFILE

psql -tc "select
			drop_stmt
		from
			(
			select
				'alter table ' || schemaname || '.' || tablename || ' drop partition \"' || partitionname || '\";' drop_stmt,
				row_number() over (partition by tablename order by partitionname desc) as rn
			from pg_partitions t
			where
				schemaname = '$SCHEMA' and
				tablename in ('p_threadinfo', 'p_serverlogs', 'p_cpu_usage', 'p_cpu_usage_report') and
				partitiontype = 'range' and
				partitionname <> '10010101'
			) a
		where
			rn > 8	
		order by 1
	" $DBNAME | psql -a $DBNAME >> $LOGFILE 2>&1

echo "End drop old partitions. " + $(date) >> $LOGFILE
