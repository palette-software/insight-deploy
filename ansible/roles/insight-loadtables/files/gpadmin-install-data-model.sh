#!/usr/bin/env bash

data_model_version=$1
if [[ -n "$data_model_version" ]]; then
    echo "Requested data model version: $data_model_version"
else
    echo "No data model version specified. Trying to install the latest one."
fi

source /usr/local/greenplum-db/greenplum_path.sh && echo $PATH
