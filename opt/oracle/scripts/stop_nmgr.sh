#!/bin/bash
#
# Start the Node Manager (command line)
#
# Source the environment
# shellcheck source=esb_env.sh
. /opt/oracle/scripts/esb_env.sh
# shellcheck source=wls_functions.sh
. /opt/oracle/scripts/wls_functions.sh

"${DOMAIN_HOME}"/bin/stopNodeManager.sh >> "${DOMAIN_HOME}"/nodemanager/logs/nodemanager.out 2>&1 &