#!/bin/bash

# Fail if there are errors
set -e

LOCKFILE=/tmp/PI_Reporting_prod.flock

flock -n ${LOCKFILE} \
  {{ insight_talend_location }}/Palette_Insight_Init_Reporting/Palette_Insight_Init_Reporting_run.sh \
    --context_param storage_path=/data/insight-server/uploads/{{ cluster_name }}
