#!/bin/bash

psql -d palette <<EOF
VACUUM {{ insight_schema_name }}.p_serverlogs;
VACUUM {{ insight_schema_name }}.p_cpu_usage;
VACUUM {{ insight_schema_name }}.p_cpu_usage_report;
VACUUM {{ insight_schema_name }}.p_interactor_session_agg_cpu_usage;
VACUUM {{ insight_schema_name }}.p_cpu_usage_agg_report;
EOF
