#!/bin/bash -l

DBNAME="palette"
SCHEMA="palette"
VCOMMAND="VACUUM ANALYZE"
LOGFILE="/home/gpadmin/db_maintenance.log"

echo "Start maintenance " + $(date) >> $LOGFILE
echo "Start vacuum analyze pg_catalog tables. " + $(date) >> $LOGFILE

psql -tc "select '$VCOMMAND ' || b.nspname || '.' || relname || ';'
from
        pg_class a,
        pg_namespace b
where
        a.relnamespace = b.oid and
        b.nspname in ('pg_catalog') and
        a.relkind='r'" $DBNAME | psql -a $DBNAME >> $LOGFILE 2>&1

echo "End vacuum analyze pg_catalog tables. " + $(date) >> $LOGFILE

echo "Start drop indexes " + $(date) >> $LOGFILE

psql $DBNAME >> $LOGFILE 2>&1 <<EOF
\set ON_ERROR_STOP on
set search_path = $SCHEMA;
begin;
select drop_child_indexes('$SCHEMA.p_cpu_usage_bootstrap_rpt_parent_vizql_session_idx');
select drop_child_indexes('$SCHEMA.p_cpu_usage_report_cpu_usage_parent_vizql_session_idx');
select drop_child_indexes('$SCHEMA.p_serverlogs_p_id_idx');
select drop_child_indexes('$SCHEMA.p_serverlogs_parent_vizql_session_idx');
select drop_child_indexes('$SCHEMA.p_serverlogs_bootstrap_rpt_parent_vizql_session_idx');

drop index p_cpu_usage_bootstrap_rpt_parent_vizql_session_idx;
drop index p_cpu_usage_report_cpu_usage_parent_vizql_session_idx;
drop index p_serverlogs_p_id_idx;
drop index p_serverlogs_parent_vizql_session_idx;
drop index p_serverlogs_bootstrap_rpt_parent_vizql_session_idx;
commit;

EOF

echo "End drop indexes " + $(date) >> $LOGFILE

echo "Start vacuum tables by new partitions " + $(date) >> $LOGFILE

psql -tc "select
				'vacuum ' || p.schemaname || '.\"' || p.partitiontablename || '\";'
			from 
				pg_partitions p
				left outer join pg_stat_operations o on (o.schemaname = p.schemaname and
														 o.objname = p.partitiontablename and
														 o.actionname = 'VACUUM'
														 )
			where 
				p.tablename in ('p_serverlogs', 
								'p_cpu_usage', 
								'p_cpu_usage_report' 
								/*'p_interactor_session',
								'p_cpu_usage_agg_report',
								'p_process_class_agg_report',
								'p_cpu_usage_bootstrap_rpt',
								'p_serverlogs_bootstrap_rpt'*/
								) and	
				p.parentpartitiontablename is null and
				o.statime is null and
				to_date(p.partitionname, 'yyyymmdd') < now()::date 
		" $DBNAME | psql -a $DBNAME >> $LOGFILE 2>&1
	
echo "End vacuum tables by new partitions " + $(date) >> $LOGFILE


echo "Start analyze tables by new partitions " + $(date) >> $LOGFILE

psql -tc "select
				'analyze ' || p.schemaname || '.\"' || p.partitiontablename || '\";'
		from 
			pg_partitions p
			left outer join pg_stat_operations o on (o.schemaname = p.schemaname and
													 o.objname = p.partitiontablename and
													 o.actionname = 'ANALYZE'
													 )
		where 
			p.tablename in ('p_serverlogs', 
							'p_cpu_usage', 
							'p_cpu_usage_report'
							/*'p_interactor_session',
							'p_cpu_usage_agg_report',
							'p_process_class_agg_report',
							'p_cpu_usage_bootstrap_rpt',
							'p_serverlogs_bootstrap_rpt'*/) and	
			p.parentpartitiontablename is not null and
			o.statime is null and 
			to_date(p.parentpartitionname, 'yyyymmdd') < now()::date
		" $DBNAME | psql -a $DBNAME >> $LOGFILE 2>&1
	
echo "End analyze tables by new partitions " + $(date) >> $LOGFILE


echo "Start vacuum analyze rest of the tables " + $(date) >> $LOGFILE

psql $DBNAME >> $LOGFILE 2>&1 <<EOF
\set ON_ERROR_STOP on
set search_path = $SCHEMA;
VACUUM ANALYZE p_interactor_session;
VACUUM ANALYZE p_cpu_usage_agg_report;
VACUUM ANALYZE p_process_class_agg_report;
VACUUM ANALYZE p_cpu_usage_bootstrap_rpt;
VACUUM ANALYZE p_serverlogs_bootstrap_rpt;

EOF

echo "End vacuum tables " + $(date) >> $LOGFILE

echo "Start create indexes " + $(date) >> $LOGFILE

psql $DBNAME >> $LOGFILE 2>&1 <<EOF
\set ON_ERROR_STOP on
set search_path = $SCHEMA;
set role palette_palette_updater;
begin;
CREATE INDEX p_cpu_usage_bootstrap_rpt_parent_vizql_session_idx ON p_cpu_usage_bootstrap_rpt USING btree (cpu_usage_parent_vizql_session);
CREATE INDEX p_cpu_usage_report_cpu_usage_parent_vizql_session_idx ON p_cpu_usage_report USING btree (cpu_usage_parent_vizql_session);
CREATE INDEX p_serverlogs_p_id_idx ON p_serverlogs USING btree (p_id);
CREATE INDEX p_serverlogs_parent_vizql_session_idx ON p_serverlogs USING btree (parent_vizql_session);
CREATE INDEX p_serverlogs_bootstrap_rpt_parent_vizql_session_idx ON p_serverlogs_bootstrap_rpt USING btree (parent_vizql_session);
commit;
EOF

echo "End create indexes " + $(date) >> $LOGFILE

echo "End maintenance " + $(date) >> $LOGFILE

