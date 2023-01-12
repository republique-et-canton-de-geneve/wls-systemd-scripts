#!/bin/bash
#
# Start the Admin Node Manager (command line)
#
# Source the environment
. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh

${DOMAIN_HOME}/servers/AdminServer/nodemanager/stopNodeManagerAdmin.sh >> ${DOMAIN_HOME}/servers/AdminServer/nodemanager/logs/nodemanager_adm.out 2>&1&