#!/bin/bash

. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh

# set -x
# find /var/opt/oracle/NodeManager -type f | xargs rm

checkServerStatus ${SERVER_HOSTNAME} ${NMGR_ADM_PORT}
CR_PORT=$?

checkProcessCwdStatus ${NMGR_ADM_SERVER_NAME} ${NMGR_ADM_CWD}
CR_PS=$?

# Force ListenAdress to physical node
sed -i s/"^ListenAddress=\(.*\)"/"ListenAddress=`hostname -s`"/g ${DOMAIN_HOME}/servers/AdminServer/nodemanager/nodemanager.properties

if [ "${CR_PORT}" -eq "0" -o "${CR_PS}" -eq "0" ]
then
	echo "Node Manager for AdminServer seems to be already running"
	exit 1
else
	/opt/oracle/scripts/mount_vip.sh
	nohup ${DOMAIN_HOME}/servers/AdminServer/nodemanager/startNodeManagerAdmin.sh > ${STDOUT_LOGS_DIR}/NodeManager/NodeManager_admin.out 2>&1&
	echo "Waiting for start end "
	COUNT=1
	CR_PORT=1
	while [ "$CR_PORT" -ne "0" -a "$COUNT" -le "6" ]
	do
		checkServerStatus ${SERVER_HOSTNAME} ${NMGR_ADM_PORT}
		CR_PORT=$?
		if [ "$CR_PORT" -ne "0" ]
		then
			echo -n "."
			sleep 10
		fi
		COUNT=$(( $COUNT + 1 ))
	done
fi

