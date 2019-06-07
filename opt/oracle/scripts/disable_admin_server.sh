#!/bin/bash
# Source the environment
. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh

cd /opt/oracle/scripts

./stop-wls-server.sh admin
./stop_nmgr_adm.sh

sudo /sbin/ifconfig eth0:1 down 2>/dev/null > /dev/null
echo $?

