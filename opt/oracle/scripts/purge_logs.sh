#!/bin/bash
#
# Removes all the old log files
#
# Source the environment
# shellcheck source=esb_env.sh
. /opt/oracle/scripts/esb_env.sh
# shellcheck source=wls_functions.sh
. /opt/oracle/scripts/wls_functions.sh

for i in $(find ${DOMAIN_HOME}/servers/ -mindepth 1 -maxdepth 1 -type d \( -name "Admin*" -o -name "WLS*" \))
do 
    cd "$i"/logs || exit
    rm -- *.log0*
    rm -- *.out 
    rm -- *diagnostic-*.log
done