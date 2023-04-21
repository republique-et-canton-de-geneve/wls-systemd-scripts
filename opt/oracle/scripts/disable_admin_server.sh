#!/bin/bash
#
# Stops the Adminserver, Admin Node Manager, and unmounts Admin VIP
# NB. This script is meant to be used by command line in case the AdminServer has to be migrated
#
# Source the environment
# shellcheck source=esb_env.sh
. /opt/oracle/scripts/esb_env.sh
# shellcheck source=wls_functions.sh
. /opt/oracle/scripts/wls_functions.sh

cd /opt/oracle/scripts || exit

./stop-wls-server.sh admin                                  # stop the Adminserver
./stop_nmgr_adm.sh                                          # stop the Admin Node Manager
sudo /sbin/ifconfig eth0:1 down 2>/dev/null > /dev/null     # Unmount the Admin VIP
echo $?