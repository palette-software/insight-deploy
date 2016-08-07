#!/bin/bash

DBNAME="palette"
SCHEMA="palette"
VCOMMAND="VACUUM ANALYZE"
LOGFILE="./kgz_maintenance.log"

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
select drop_child_indexes('$SCHEMA.p_cpu_usage_bootstrap_rpt_parent_vizql_sessio                                                                                                             n_idx');
select drop_child_indexes('$SCHEMA.p_cpu_usage_report_cpu_usage_parent_vizql_ses                                                                                                             sion_idx');
select drop_child_indexes('$SCHEMA.p_serverlogs_p_id_idx');
select drop_child_indexes('$SCHEMA.p_serverlogs_parent_vizql_session_idx');
select drop_child_indexes('$SCHEMA.p_serverlogs_bootstrap_rpt_parent_vizql_sessi                                                                                                             on_idx');

drop index p_cpu_usage_bootstrap_rpt_parent_vizql_session_idx;
drop index p_cpu_usage_report_cpu_usage_parent_vizql_session_idx;
drop index p_serverlogs_p_id_idx;
drop index p_serverlogs_parent_vizql_session_idx;
drop index p_serverlogs_bootstrap_rpt_parent_vizql_session_idx;

EOF

echo "End drop indexes " + $(date) >> $LOGFILE

echo "Start vacuum tables " + $(date) >> $LOGFILE


psql $DBNAME >> $LOGFILE 2>&1 <<EOF
\set ON_ERROR_STOP on
set search_path = $SCHEMA;
VACUUM ANALYZE p_serverlogs;
VACUUM ANALYZE p_cpu_usage;
VACUUM ANALYZE p_cpu_usage_report;
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

CREATE INDEX p_cpu_usage_bootstrap_rpt_parent_vizql_session_idx ON p_cpu_usage_b                                                                                                             ootstrap_rpt USING btree (cpu_usage_parent_vizql_session);

CREATE INDEX p_cpu_usage_report_cpu_usage_parent_vizql_session_idx ON p_cpu_usag                                                                                                             e_report USING btree (cpu_usage_parent_vizql_session);

CREATE INDEX p_serverlogs_p_id_idx ON p_serverlogs USING btree (p_id);

CREATE INDEX p_serverlogs_parent_vizql_session_idx ON p_serverlogs USING btree (                                                                                                             parent_vizql_session);

CREATE INDEX p_serverlogs_bootstrap_rpt_parent_vizql_session_idx ON p_serverlogs                                                                                                             _bootstrap_rpt USING btree (parent_vizql_session);
EOF

echo "End create indexes " + $(date) >> $LOGFILE

echo "End maintenance " + $(date) >> $LOGFILE
