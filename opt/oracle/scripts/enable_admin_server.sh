#!/bin/bash

# Source the environment
. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh

cd /opt/oracle/scripts

./start_nmgr_adm.sh

NETMASK=`ifconfig eth0 | egrep netmask | sed s/'\(.*\)netmask \([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)\(.*\)'/"\2"/g`
#NETMASK=${VIP_NETMASK}

ping -c1 -i3 adminserver 2>/dev/null > /dev/null
if [ "$?" -ne "0" ]
then
	# nobody listening on adminserver ip
	IP=`egrep "adminserver" /etc/hosts | awk '{print($1)}'`
	echo -n "Mount $IP on eth0:1"
	sudo /sbin/ifconfig eth0:1 ${IP} netmask ${NETMASK}
	checkExitCode $?
else
	echo "Adminserver IP already mounted (maybe on the other node)"
fi

./start-wls-server.sh admin

