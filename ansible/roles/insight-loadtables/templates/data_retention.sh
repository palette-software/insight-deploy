#!/bin/bash

DBNAME="palette"
SCHEMA="palette"
LOGFILE="./retention.log"


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
				tablename in ('threadinfo', 'serverlogs', 'p_threadinfo', 'p_serverlogs', 'p_cpu_usage', 'p_cpu_usage_report') and
				partitiontype = 'range' and
				partitionname <> '10010101'
			) a
		where
			rn > 15
		order by 1
	" $DBNAME | psql -a $DBNAME >> $LOGFILE 2>&1

echo "End drop old partitions. " + $(date) >> $LOGFILE


delete from palette.http_requests as t
using
	(
	
	with t_dates 
	as
	(
	select 
		distinct created_at::date as created_at_date
	from 
		palette.http_requests
	)
	
	select
		created_at_date
	from	
		(
		select 
			d.created_at_date,
			row_number() over (order by d.created_at_date desc) as rn
		from 
			t_dates d
		) a	
	where
		rn > 15
		) s
where
	t.created_at::date = s.created_at_date

	