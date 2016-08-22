#!/bin/bash

# Fail if there are errors
set -e

LOCKFILE=/tmp/sanity_check.flock

flock -n ${LOCKFILE} \
	{{ sanity_check_install_dir }}/dbcheck {{ sanity_check_install_dir }}/tests/sanity_checks.yml {{ sanity_check_install_dir }}/Config.yml > /dev/null
