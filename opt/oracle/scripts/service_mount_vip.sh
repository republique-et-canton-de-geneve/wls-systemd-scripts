#!/bin/bash

# Source the environment
#. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh
#set -x
export TERM=xterm
TMP=`hostname -s`
NODE=`echo ${TMP:(-1)}`
NETMASK=`ifconfig eth0 | egrep netmask | sed s/'\(.*\)netmask \([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)\(.*\)'/"\2"/g`

ping -c1 -i3 adminserver 2>/dev/null > /dev/null
if [ "$?" -ne "0" ]
then
	# nobody listening on adminserver ip
	IP=`egrep "adminserver" /etc/hosts | awk '{print($1)}'`
	echo -n "Mount $IP on eth0:1"
	/sbin/ifconfig eth0:1 ${IP} netmask ${NETMASK}
	checkExitCode $?
else
	echo "Adminserver IP already mounted (maybe on the other node)"
fi

ifconfig |egrep -wq "^eth0:2"
if [ "$?" -eq "1" ]
then
	IP=`egrep "osbhost${NODE}vhn1" /etc/hosts | awk '{print($1)}'`
	/sbin/ifconfig eth0:2 ${IP} netmask ${NETMASK}
	checkExitCode $?
else
	echo "eth0:2 already mounted"
fi

ifconfig |egrep -wq "^eth0:3"
if [ "$?" -eq "1" ]
then
	IP=`egrep "osbhost${NODE}vhn2" /etc/hosts | awk '{print($1)}'`
	/sbin/ifconfig eth0:3 ${IP} netmask ${NETMASK}
	checkExitCode $?
else
	echo "eth0:3 already mounted"
fi

