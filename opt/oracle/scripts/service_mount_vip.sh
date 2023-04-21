#!/bin/bash
#
# Mounts all the min VIP based on which node it is (systemd)
#
# Source the environment
# shellcheck source=esb_env.sh
. /opt/oracle/scripts/esb_env.sh
# shellcheck source=service_wls_functions.sh
. /opt/oracle/scripts/service_wls_functions.sh

export TERM=dumb

if ! ping -c1 -i3 adminvhn 2>/dev/null > /dev/null
then
	# nobody listening on adminvhn ip
	IP=$(grep -E "adminvhn" /etc/hosts | awk '{print($1)}')
	echo -n "Mount $IP on eth0:1"
	/sbin/ifconfig eth0:1 "${IP}" netmask "${NETMASK}"
	checkExitCode $?
else
	echo "Adminserver IP already mounted (maybe on the other node)"
fi

ifconfig | grep -Ewq "^eth0:2"
if [ "$?" -eq "1" ]
then
	IP=$(grep -E "osbhost${NODE}vhn1" /etc/hosts | awk '{print($1)}')
	/sbin/ifconfig eth0:2 "${IP}" netmask "${NETMASK}"
	checkExitCode $?
else
	echo "eth0:2 already mounted"
fi

ifconfig | grep -Ewq "^eth0:3"
if [ "$?" -eq "1" ]
then
	IP=$(grep -E "osbhost${NODE}vhn2" /etc/hosts | awk '{print($1)}')
	/sbin/ifconfig eth0:3 "${IP}" netmask "${NETMASK}"
	checkExitCode $?
else
	echo "eth0:3 already mounted"
fi