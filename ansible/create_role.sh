#!/bin/sh

echo "Usage: $0 <ROLE_NAME>"
START_DIR=`pwd`

cd roles
mkdir -p $1 && cd $1

for dirName in tasks handlers templates files vars meta
do
  if [ ! -d $dirName ]
  then
    echo "+ Creating: $dirName in `pwd`"
    mkdir $dirName
    echo "---" > $dirName/main.yml
  else
    echo "Skipping: $dirName"
  fi
done

cd $START_DIR
