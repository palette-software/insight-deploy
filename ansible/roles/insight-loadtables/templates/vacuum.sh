#!/bin/bash -l

psql -d palette >/var/log/vacuum/vacuum.log 2>&1 <<EOF
VACUUM ANALYZE {{ insight_schema_name }}.p_serverlogs;
VACUUM ANALYZE {{ insight_schema_name }}.p_cpu_usage;
VACUUM ANALYZE {{ insight_schema_name }}.p_cpu_usage_report;
VACUUM ANALYZE {{ insight_schema_name }}.p_interactor_session;
VACUUM ANALYZE {{ insight_schema_name }}.p_cpu_usage_agg_report;
EOF
