#!/bin/bash -el


PG_PASSWORD=$1

psql -d palette <<EOF
create user datadog with password '${PG_PASSWORD}';
grant SELECT ON pg_stat_database to datadog;
EOF

