#!/bin/bash
#
# Start the Node Manager (systemd)
# NB. There is no stop script for systemd because the service uses automatic killmode
#
# Source the environment
# shellcheck source=esb_env.sh
. /opt/oracle/scripts/esb_env.sh
# shellcheck source=service_wls_functions.sh
. /opt/oracle/scripts/service_wls_functions.sh

export TERM=dumb

checkServerStatus "${SERVER_HOSTNAME}" "${NMGR_PORT}"
CR_PORT=$?

checkProcessCwdStatus "${NMGR_SERVER_NAME}" "${NMGR_CWD}"
CR_PS=$?

# Force ListenAdress to physical node
sed -i s/"^ListenAddress=\(.*\)"/"ListenAddress=$(hostname -s)"/g "${DOMAIN_HOME}"/nodemanager/nodemanager.properties

if [ "${CR_PORT}" -eq "0" -o "${CR_PS}" -eq "0" ]
then
	# echo "Node Manager seems to be already running"
	exit 1
else
	# /opt/oracle/scripts/mount_vip.sh					# Mounting the VIP is part of a depending systemd service, no need to chain
	nohup "${DOMAIN_HOME}"/bin/startNodeManager.sh >> "${DOMAIN_HOME}"/nodemanager/logs/nodemanager.out 2>&1 &
	# echo "Waiting for start end "
	COUNT=1
	CR_PORT=1
	while [ "$CR_PORT" -ne "0" -a "$COUNT" -le "6" ]
	do
		checkServerStatus "${SERVER_HOSTNAME}" "${NMGR_PORT}"
		CR_PORT=$?
		if [ "$CR_PORT" -ne "0" ]
		then
			# echo -n "."
			sleep 10
		fi
		COUNT=$(( COUNT + 1 ))
	done
fi