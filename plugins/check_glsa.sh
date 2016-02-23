#!/bin/bash


#######################
## nagios exit codes ##
#######################

state_ok=0
state_warning=1
state_critical=2
state_unknown=3
state_dependent=4


COUNT=$(glsa-check -q -l affected 2>/dev/null|grep "\[N\]"|wc -l)
if [ "$?" -ne "0" ]; then
	echo "Command failed" 
	exit $state_unknown
fi

if [ "${COUNT}" -eq "0" ]; then
	echo "No GLSA warnings"
	exit $state_ok
fi

if [ "${COUNT}" -gt "0" ]; then
	echo "There is ${COUNT} GLSA warnings..."
	exit $state_warning
fi

exit $state_ok


