#!/bin/bash

DISK=$1

if [ -z "$DISK" ]; then
	echo "No disk specified!"
	exit 3
fi

STATE=`grep -E "^${DISK} " /proc/mdstat -A 1`

if [ $? -ne 0 ]; then
	echo "Failed to query array ${DISK}"
	exit 3
fi
VER=`echo $STATE | sed -e 's/^[^:]*: \([^ \t]*\).*blocks[^]]*\][^[]\[\([^]]*\).*$/\1:\2/'`

if [ $? -ne 0 ]; then
        echo "Failed to process info for ${DISK}"
        exit 3
fi

STATUS=`echo ${VER} | cut -f 1 -d :` 
if [ "${STATUS}" != "active" ]; then
	echo "Status of array is ${STATUS}"
	exit 2
fi

FAILED=`echo ${VER} | cut -f 2 -d :  | grep -o _ | wc -l` 
UP=`echo ${VER} | cut -f 2 -d : | grep -o U | wc -l` 

if [ "${FAILED}" -ne "0" ]; then
	echo "Array ${DISK} has ${FAILED} failed disks!!"
	exit 2
fi

echo "Array ${DISK} is active with ${UP} disks up"
exit 0
 	
