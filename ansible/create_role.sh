#!/bin/bash -ex

set -e

echo "Usage: $0 <ROLE_NAME>"
START_DIR=`pwd`

pushd roles
mkdir -p $1 && cd $1

for dirName in tasks handlers templates files vars meta
do
  if [ ! -d $dirName ]
  then
    echo "+ Creating: $dirName in `pwd`"
    mkdir -p $dirName
  else
    echo "Skipping: $dirName"
  fi
done

for dirName in tasks handlers vars meta
do
  if [ ! -f $dirName/main.yml ]
  then
    echo "+ Adding main.yml to: $dirName in `pwd`"
    echo "---" > $dirName/main.yml
  else
    echo "Skipping: $dirName/main.yml"
  fi
done

popd
