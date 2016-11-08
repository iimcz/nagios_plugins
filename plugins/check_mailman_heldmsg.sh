#!/bin/bash


#######################
## nagios exit codes ##
#######################

state_ok=0
state_warning=1
state_critical=2
state_unknown=3
state_dependent=4

HELD_COUNT=$(ls -1 /var/lib/mailman/data/heldmsg* 2>/dev/null|wc -l)

if [ -z "${HELD_COUNT}" ]; then
	echo "Error occured while querying mailman status!"
	exit $state_unknown
fi

if [ "${HELD_COUNT}" -gt "0" ]; then
	LISTS=$(ls -1 /var/lib/mailman/data/held*|xargs -I {} basename  {} .pck|sed -e 's/heldmsg-\(.*\)-[0-9]*$/\1/'|sort|uniq)
	echo "There are ${HELD_COUNT} messages in lists: $(echo ${LISTS})"
	exit $state_critical
fi

echo "No held messages"

exit $state_ok


