#!/bin/bash

. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh

find ${STDOUT_LOGS_DIR}/NodeManager -type f -mtime +60 | xargs rm

${DOMAIN_HOME}/servers/AdminServer/nodemanager/stopNodeManagerAdmin.sh > ${STDOUT_LOGS_DIR}/NodeManager/NodeManager.out 2>&1&

