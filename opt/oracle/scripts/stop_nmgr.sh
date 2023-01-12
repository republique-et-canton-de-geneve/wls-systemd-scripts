#!/bin/bash
#
# Start the Node Manager (command line)
#
# Source the environment
. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh

${DOMAIN_HOME}/bin/stopNodeManager.sh >> ${DOMAIN_HOME}/nodemanager/logs/nodemanager.out 2>&1 &

