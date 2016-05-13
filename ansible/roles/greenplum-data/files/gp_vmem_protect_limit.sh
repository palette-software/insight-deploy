#!/bin/bash

set -e

# Check arg count
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <VCPU_COUNT> <OTHER_MEMORY_MB>"
  exit 1
fi

FREE_OUTPUT=`free -g`
RAM=`free -m | perl -l -ne '/Mem:\s+(\d+)/ && print $1'`
SWAP=`free -m | perl -l -ne '/Swap:\s+(\d+)/ && print $1'`
NumOfSegs=$1
GPDBOtherMem=$2

python -c "
import math
import sys

ram = ${RAM}
swap = ${SWAP}


usermem = (ram + swap - ((7.5 * 1024) + (ram * 0.05)))
kernelmem = (0.026 * (usermem / 1.7))

OvercommitRatio = math.floor((((ram - kernelmem) / ram) * 100) / 5) * 5
SuggestedVmem = round( math.ceil(((((usermem - ${GPDBOtherMem}) / 1.7 ) / ${NumOfSegs}))))

gp_vmem_protect_limit = int( ((math.floor((SuggestedVmem + 50) / 100) * 100) or SuggestedVmem) )
print gp_vmem_protect_limit

if gp_vmem_protect_limit < 0:
  print 'Not enough memory on the system'
  sys.exit(1)
else:
  print gp_vmem_protect_limit
"
