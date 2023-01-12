#!/bin/bash
#
# Mounts all the min VIP based on which node it is (command line)
#
# Source the environment
. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh

ping -c1 -i3 adminvhn 2>/dev/null > /dev/null
if [ "$?" -ne "0" ]
then
	# nobody listening on adminvhn ip
	IP=`egrep "adminvhn" /etc/hosts | awk '{print($1)}'`
	echo -n "Mount $IP on ens3:1"
	sudo /sbin/ifconfig ens3:1 ${IP} netmask ${NETMASK}
	checkExitCode $?
else
	echo "Adminserver IP already mounted (maybe on the other node)"
fi

ifconfig |egrep -wq "^ens3:2"
if [ "$?" -eq "1" ]
then
	IP=`egrep "osbhost${NODE}vhn1" /etc/hosts | awk '{print($1)}'`
	sudo /sbin/ifconfig ens3:2 ${IP} netmask ${NETMASK}
	checkExitCode $?
else
	echo "ens3:2 already mounted"
fi

ifconfig |egrep -wq "^ens3:3"
if [ "$?" -eq "1" ]
then
	IP=`egrep "osbhost${NODE}vhn2" /etc/hosts | awk '{print($1)}'`
	sudo /sbin/ifconfig ens3:3 ${IP} netmask ${NETMASK}
	checkExitCode $?
else
	echo "ens3:3 already mounted"
fi
