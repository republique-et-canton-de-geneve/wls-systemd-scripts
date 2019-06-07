#!/bin/bash
#
# Starts WLS admin server and managed servers
#
# Source the environment
. /opt/oracle/scripts/esb_env.sh
. /opt/oracle/scripts/wls_functions.sh

printUsage()
{
        echo "Usage: $0 <admin|soa|osb|wsm>"
        exit 1
}

startAdminServer()
{
        # checking if adminserver should be started on this node
        ifconfig | egrep -wq `egrep "${ADMIN_HOSTNAME}" /etc/hosts | awk '{print($1)}'`
        [ "$?" -ne "0" ] && echo "Adminserver not migrated on this server" && exit 0
        #export PROXY_SETTINGS="-Dhttp.proxySet=true -Dhttp.proxyHost=www-proxy.us.oracle.com -Dhttp.proxyPort=80 -Dhttp.nonProxyHosts=localhost|${HOST}|*.us.oracle.com|*.local"
        status=`checkServerStatusUP ${ADMIN_HOSTNAME} ${ADMIN_PORT}`
        if [ $status = "DOWN" ]
        then
                cd $DOMAIN_HOME
                bin/startWebLogic.sh > ${STDOUT_LOGS_DIR}/AdminServer/start_AdminServer.log 2>&1 &
                admin_status="DOWN"
                echo -n "Starting Admin Server ..."
                while [ $admin_status = "DOWN"  ]
                do
                        echo -n "."
                        sleep 30
                        procRunning=$(ps -ef | grep AdminServer | grep -v grep | grep java | wc -l)
                        if [ $procRunning -eq 0 ]
                        then
                                echo "AdminServer failed to start. Check ${STDOUT_LOGS_DIR}/AdminServer/start_AdminServer.log"
                                exit 1
                        fi
                        admin_status=`checkServerStatusUP ${ADMIN_HOSTNAME} $ADMIN_PORT`
                done
                echo "OK"
                exit 0;
        else
		echo "Admin Server is already running."
		exit 0;
        fi
}

# Usage startServer server-name server-port
startServer()
{
	SRV_NAME=$1
	HOSTN=$2
	PORTN=$3
        status=`checkServerStatusUP ${ADMIN_HOSTNAME} ${ADMIN_PORT}`
        if [ $status = "DOWN" ]
        then
                echo "AdminServer is down. Please start admin server before starting $1"
                exit 1
        fi
	status=`checkServerStatusUP $HOSTN $PORTN`
	if [ $status = "DOWN" ]
	then
		cd $DOMAIN_HOME
		echo -n "Starting $1 ..."
		bin/startManagedWebLogic.sh $SRV_NAME > ${STDOUT_LOGS_DIR}/$SRV_NAME/start_${SRV_NAME}.log 2>&1 &
		status=`checkServerStatusUP $HOSTN $PORTN`
		while [ $status = "DOWN"  ]
		do
			echo -n "."
			sleep 30
			procRunning=$(ps -ef | grep $SRV_NAME | grep -v grep | grep java | wc -l)
			if [ $procRunning -eq 0 ]
			then
				echo "$SRV_NAME failed to start. Check ${STDOUT_LOGS_DIR}/$SRV_NAME/start_${SRV_NAME}.log"
				exit 1
			fi
			status=`checkServerStatusUP $HOSTN $PORTN`
		done
		echo "OK"
		exit 0
	else
		echo "$1 is already running"
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
			true
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager admin inaccessible" && exit 1
			
			checkProcessCwdStatus ${NMGR_ADM_SERVER_NAME} ${NMGR_ADM_CWD}
			true
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager admin inaccessible" && exit 1
			
			startAdminServer
			;;
			
		'soa')
			checkServerStatus ${SERVER_HOSTNAME} ${NMGR_PORT}
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager inaccessible" && exit 1
			
			checkProcessCwdStatus ${NMGR_SERVER_NAME} ${NMGR_CWD}
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager inaccessible" && exit 1
			
			export JAVA_OPTIONS=${WLS_AGENT_DYNA_SOA} ${JAVA_OPTIONS}
			startServer $SOA_SERVER_NAME $SOA_HOSTNAME $SOA_PORT
			;;
			
		'osb')
			checkServerStatus ${SERVER_HOSTNAME} ${NMGR_PORT}
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager inaccessible" && exit 1
			
			checkProcessCwdStatus ${NMGR_SERVER_NAME} ${NMGR_CWD}
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager inaccessible" && exit 1
			
			export JAVA_OPTIONS=${WLS_AGENT_DYNA_OSB} ${JAVA_OPTIONS}
			startServer $OSB_SERVER_NAME $OSB_HOSTNAME $OSB_PORT
			;;
			
		'wsm')
			checkServerStatus ${SERVER_HOSTNAME} ${NMGR_PORT}
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager inaccessible" && exit 1
			
			checkProcessCwdStatus ${NMGR_SERVER_NAME} ${NMGR_CWD}
			[ "$?" -ne "0" ] && echo "ERREUR : Node manager inaccessible" && exit 1
			
			export JAVA_OPTIONS=${WLS_AGENT_DYNA_WSM} ${JAVA_OPTIONS}
			startServer $WSM_SERVER_NAME $WSM_HOSTNAME $WSM_PORT
			;;
			
		*)
			printUsage
			;;
        esac
done

