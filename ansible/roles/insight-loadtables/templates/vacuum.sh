#!/bin/bash -l

psql -d palette >/var/log/vacuum/vacuum.log 2>&1 <<EOF
VACUUM {{ insight_schema_name }}.p_serverlogs;
VACUUM {{ insight_schema_name }}.p_cpu_usage;
VACUUM {{ insight_schema_name }}.p_cpu_usage_report;
VACUUM {{ insight_schema_name }}.p_interactor_session;
VACUUM {{ insight_schema_name }}.p_cpu_usage_agg_report;
VACUUM {{ insight_schema_name }}.p_process_class_agg_report;
EOF
