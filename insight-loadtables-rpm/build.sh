#!/bin/sh
PWD=`pwd`

echo $PWD

rpmbuild -bb\
  --buildroot "${PWD}/_root"\
  --define "_rpmdir $PWD/_build"\
  palette-insight-loadtables.spec

