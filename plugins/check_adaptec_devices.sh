#!/bin/bash

ERRS=`/usr/bin/arcconf GETCONFIG 1 PD|grep S.M.A.R.T.| cut -f 2 -d \: | grep Yes | wc -l`

if [ "${ERRS}" -ne "0" ]; then
	echo "${ERRS} physical devices have smart errors";
	exit 2;
fi

echo "All physical devices are ok"

exit 0
