#!/bin/bash
#
# Stop WLS admin server and managed servers
# 
# modified for this environment: FBI
#
# Source the environment
. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh

printUsage()
{
        echo "Usage: $0 <admin|soa|osb|wsm>"
        exit 1
}

stopAdminServer()
{
        status=`checkServerStatusUP ${ADMIN_HOSTNAME} ${ADMIN_PORT}`
        if [ $status = "UP" ]
        then
                echo "Stopping Admin Server..."
                cd $DOMAIN_HOME
                sh bin/stopWebLogic.sh
                status=`checkServerStatusUP $ADMIN_PORT`
                if [ $status = "DOWN" ]
                then
                        echo "OK"
                        exit 0;
		else
			echo "Failed to stop Admin server"
			exit 1;
		fi
        else
		echo "Admin Server is already stopped."
		exit 0;
        fi
}

# Usage stopServer server-name server-port
stopServer()
{
	SRV_NAME=$1
	HOSTN=$2
	PORTN=$3
	status=`checkServerStatusUP $HOSTN $PORTN`
	if [ $status = "UP" ]
	then
		cd $DOMAIN_HOME
		echo "Stopping $1 ..."
		bin/stopManagedWebLogic.sh $SRV_NAME
		status=`checkServerStatusUP $HOSTN $PORTN`
		while [ $status = "UP"  ]
		do
			echo -n "."
			sleep 30
			status=`checkServerStatusUP $HOSTN $PORTN`
		done
		echo "OK"
		exit 0
	else
		echo "$1 is already stopped"
		exit 0;
	fi
}

#----------------------------------
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
			checkServerStatus ${SERVER_HOSTNAME} ${NMGR_ADM_PORT}
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager admin inaccessible" && exit 1
			
			checkProcessCwdStatus ${NMGR_ADM_SERVER_NAME} ${NMGR_ADM_CWD}
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager admin inaccessible" && exit 1
			
			stopAdminServer
			;;
			
		'soa')
			checkServerStatus ${SERVER_HOSTNAME} ${NMGR_PORT}
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager inaccessible" && exit 1
			
			checkProcessCwdStatus ${NMGR_SERVER_NAME} ${NMGR_CWD}
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager inaccessible" && exit 1
			
			export JAVA_OPTIONS=${WLS_AGENT_DYNA_SOA} ${JAVA_OPTIONS}
			stopServer $SOA_SERVER_NAME $SOA_HOSTNAME $SOA_PORT
			;;
			
		'osb')
			checkServerStatus ${SERVER_HOSTNAME} ${NMGR_PORT}
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager inaccessible" && exit 1
			
			checkProcessCwdStatus ${NMGR_SERVER_NAME} ${NMGR_CWD}
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager inaccessible" && exit 1
			
			export JAVA_OPTIONS=${WLS_AGENT_DYNA_OSB} ${JAVA_OPTIONS}
			stopServer $OSB_SERVER_NAME $OSB_HOSTNAME $OSB_PORT
			;;
			
		'wsm')
			checkServerStatus ${SERVER_HOSTNAME} ${NMGR_PORT}
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager inaccessible" && exit 1
			
			checkProcessCwdStatus ${NMGR_SERVER_NAME} ${NMGR_CWD}
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager inaccessible" && exit 1
			
			export JAVA_OPTIONS=${WLS_AGENT_DYNA_WSM} ${JAVA_OPTIONS}
			stopServer $WSM_SERVER_NAME $WSM_HOSTNAME $WSM_PORT
			;;
			
		*)
			printUsage
			;;
        esac
done

