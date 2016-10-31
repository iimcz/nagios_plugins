#!/bin/bash


#######################
## nagios exit codes ##
#######################

state_ok=0
state_warning=1
state_critical=2
state_unknown=3
state_dependent=4

if [ -z "$1" ]; then
	echo "Pool name not specified"
	exit $state_unknown
fi

#COUNT=$(glsa-check -q -l affected 2>/dev/null|grep "\[N\]"|wc -l)
STATE=$( zpool status $1 | grep state|cut -f 2 -d \: |tr -d ' ')

if [ "$?" -ne "0" ]; then
	echo "Command failed" 
	exit $state_unknown
fi

echo "Zpool $1 ${STATE}"


if [ "${STATE}" = "ONLINE" ]; then
	exit $state_ok
fi
if [ "${STATE}" = "DEGRADED" ]; then
	exit $state_warning
fi


echo "Zpool ${STATE}"
exit $state_critical

