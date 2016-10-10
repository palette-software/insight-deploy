#!/bin/bash

# Fail if there are errors
set -e

{{ insight_talend_location }}/Palette_Insight_Init_ImportTable/Palette_Insight_Init_ImportTable_run.sh \
  --context_param storage_path=/data/insight-server/uploads/palette
