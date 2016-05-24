#!/bin/sh

set -e

echo "Usage: $0 <ROLE_NAME>"
START_DIR=`pwd`

cd roles
mkdir -p $1 && cd $1

for dirName in tasks handlers templates files vars meta
do
  if [ ! -d $dirName ]
  then
    echo "+ Creating: $dirName in `pwd`"
  else
    echo "Skipping: $dirName"
  fi
done

for dirName in tasks handlers vars meta
do
  if [ ! -f $dirName/mail.yml ]
  then
    echo "+ Adding mail.yml to: $dirName in `pwd`"
    echo "---" > $dirName/main.yml
  else
    echo "Skipping: $dirName/mail.yml"
  fi
done

cd $START_DIR
