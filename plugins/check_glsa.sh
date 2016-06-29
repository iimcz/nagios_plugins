#!/bin/bash


#######################
## nagios exit codes ##
#######################

state_ok=0
state_warning=1
state_critical=2
state_unknown=3
state_dependent=4



#COUNT=$(glsa-check -q -l affected 2>/dev/null|grep "\[N\]"|wc -l)
GLSAS=$(glsa-check -q -n -l affected 2>/dev/null|grep "\[N\]"| cut -f 1 -d \ )

if [ "$?" -ne "0" ]; then
	echo "Command failed" 
	exit $state_unknown
fi


COUNT=$(echo ${GLSAS}|wc -w)
RAW_PACKAGES=$(for i in ${GLSAS}; do glsa-check -q -d ${i}|grep "Affected package"|cut -f 2- -d \: | sed -e 's/^ *\([^ ].*[^ ]\) *$/\1/'; done| sort |uniq)

if [ "${COUNT}" -eq "0" ]; then
	echo "No GLSA warnings"
	exit $state_ok
fi

if [ "${COUNT}" -gt "0" ]; then
	echo "There is ${COUNT} GLSA warnings..."
	for p in ${RAW_PACKAGES}; do
		if eix -Icq ^${p}$; then PACKAGES="${PACKAGES} ${p}"; fi
	done
	echo ${PACKAGES}
	exit $state_warning
fi

exit $state_ok


