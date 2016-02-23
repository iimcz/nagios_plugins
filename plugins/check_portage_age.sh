#!/bin/bash


#######################
## nagios exit codes ##
#######################

state_ok=0
state_warning=1
state_critical=2
state_unknown=3
state_dependent=4


AGE_WARN=$((14 * 24)) # 2 weeks
AGE_CRIT=$((28 * 24)) # 4 weeks

TIMESTAMP=/usr/portage/metadata/timestamp.x

if [ ! -e "${TIMESTAMP}" ]; then
	echo "File ${TIMESTAMP} does not exist!"
	exit $state_unknown
fi

if [ ! -f "${TIMESTAMP}" ]; then
	echo "${TIMESTAMP} is not a file!"
	exit $state_unknown
fi

AGE=$((  ($(date +%s) - $(cut -f 1 -d \  "${TIMESTAMP}" ))/3600 ))
if [ "$?" != "0" ]; then
	echo "Failed to fetch timestamp!"
	exit $state_unknown
fi

if [ "${AGE}" -lt "0" ]; then
	echo "Portage is $((AGE / 24)) days from future!!"
	exit $state_unknown
fi


echo "Portage is $((AGE/24)) days old."

if [ "${AGE}" -gt "${AGE_CRIT}" ]; then
	exit $state_critical
fi

if [ "${AGE}" -gt "${AGE_WARN}" ]; then
	exit $state_warning
fi


exit $state_ok


