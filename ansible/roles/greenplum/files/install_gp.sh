#!/bin/sh

# Check arg count
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <ARCHIVE> <INSTALL_PATH>"
  exit 1
fi

archivePath=$1
installPath=$2
SKIP=`awk '/^__END_HEADER__/ {print NR + 1; exit 0; }' "${archivePath}"`

echo "Extracting to ${installPath}, skipping ${SKIP} bytes"

tail -n +${SKIP} "${archivePath}" | tar xzf - -C ${installPath}

