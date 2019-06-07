#!/bin/bash

. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh

echo "ENV $ENV"
echo "${ENV:0:1}"

ifconfig | egrep -wq `egrep "${ADMIN_HOSTNAME}" /etc/hosts | awk '{print($1)}'`
[ "$?" -eq "0" ] && echo "Current server is admin server, syncing seems a bad idea" && exit 1

export BACKUP_SRC=`ssh -oStrictHostKeyChecking=no -oBatchMode=yes adminvhn 'hostname -s'`
[ -z "$BACKUP_SRC" ] && echo "Cant get admin node url" && exit 2
echo "Syncing from ${BACKUP_SRC}"
ksh /home/${USER}/scripts/6683/${ENV:0:1}970J/sync.ksh

