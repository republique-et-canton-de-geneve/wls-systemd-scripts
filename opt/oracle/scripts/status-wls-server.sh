#!/bin/bash
#
# Check status of node manager, admin server and all nodes (command line)
#
# Source the environment
. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh

if [ $# -eq 0 ]
then
        printUsage
else
        args=$*
fi

for arg in $args
do
	case $arg in
		'admin')
			checkServerStatus ${ADMIN_HOSTNAME} ${ADMIN_PORT}
			ip a | egrep -wq `egrep "${ADMIN_HOSTNAME}" /etc/hosts | awk '{print($1)}'`
			if [ "$?" -ne "0" ]
			then
				echo "Adminserver not migrated on this server"
			else
				checkProcessStatus ${ADMIN_SERVER_NAME}
			fi
			;;
			
		'soa')
			checkServerStatus ${SOA_HOSTNAME} ${SOA_PORT}
			checkProcessStatus ${SOA_SERVER_NAME}
			;;
			
		'osb')
			checkServerStatus ${OSB_HOSTNAME} ${OSB_PORT}
			checkProcessStatus ${OSB_SERVER_NAME}
			;;
			
		'wsm')
			checkServerStatus ${WSM_HOSTNAME} ${WSM_PORT}
			checkProcessStatus ${WSM_SERVER_NAME}
			;;
			
		'nmgr')
			checkServerStatus ${SERVER_HOSTNAME} ${NMGR_PORT}
			checkProcessCwdStatus ${NMGR_SERVER_NAME} ${NMGR_CWD}
			;;
			
		'nmgr_adm')
			checkServerStatus ${SERVER_HOSTNAME} ${NMGR_ADM_PORT}
			checkProcessCwdStatus ${NMGR_SERVER_NAME} ${NMGR_ADM_CWD}
			;;
			
		'ALL')
			for composant in nmgr_adm admin nmgr soa osb wsm
			do
				echo "= $composant =========="
				$0 $composant
			done
			;;
			
		*)
			printUsage
			;;
	esac
done

