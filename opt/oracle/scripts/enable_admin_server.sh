#!/bin/bash
#
# Mounts Admin VIP the, starts Admin Node Manager, and starts AdminServer
# NB. This script is meant to be used by command line in case the AdminServer has to be migrated
#
# Source the environment
. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh

# Mount the Admin VIP
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

cd /opt/oracle/scripts
./start_nmgr_adm.sh														# start the Admin Node Manager
./start-wls-server.sh admin												# start the Adminserver

