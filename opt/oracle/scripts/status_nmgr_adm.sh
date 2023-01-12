#!/bin/bash
#
# Gives status the Admin Node Manager (command line)
#
# Source the environment
. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh

checkServerStatus ${SERVER_HOSTNAME} ${NMGR_ADM_PORT}
CR_PORT=$?

checkProcessCwdStatus ${NMGR_SERVER_NAME} ${NMGR_ADM_CWD}
CR_PS=$?

if [ "${CR_PORT}" -eq "0" -o "${CR_PS}" -eq "0" ]
then
	echo "Admin Node Manager is running"
else
	echo "Admin Manager is stopped"
fi

