#!/bin/bash

F=`/usr/bin/arcconf GETCONFIG 1 AD | grep "Logical devices/Failed/Degraded " | cut -f 2 -d :`

LOG=`echo ${F}|cut -f 1 -d /`
FAILED=`echo ${F}|cut -f 2 -d /`
DEGRADED=`echo ${F}|cut -f 3 -d /`

if [ "${FAILED}" -ne "0" ]; then
	echo "${FAILED} failed logical devices! ${DEGRADED} degraded";
	exit 2;
fi

if [ "${DEGRADED}" -ne "0" ]; then
	echo "${FAILED} failed logical devices! ${DEGRADED} degraded";
	exit 1;
fi

echo "${LOG} logical devices online, no failed or degraded"
exit 0
