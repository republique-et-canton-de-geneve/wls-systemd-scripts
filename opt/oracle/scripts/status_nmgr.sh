#!/bin/bash

. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh

checkServerStatus ${SERVER_HOSTNAME} ${NMGR_PORT}
CR_PORT=$?

checkProcessCwdStatus ${NMGR_SERVER_NAME} ${NMGR_CWD}
CR_PS=$?

if [ "${CR_PORT}" -eq "0" -o "${CR_PS}" -eq "0" ]
then
	echo "Node Manager is running"
else
	echo "Node Manager is stopped"
fi

