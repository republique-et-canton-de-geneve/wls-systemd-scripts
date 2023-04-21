#!/bin/bash
#
# Sets up the environment for starting and stopping the WLS admin and managed servers

# the NODE variable will be used to determine which servers to start, this is based on a naming convention -> customize to your environment
SERVER_HOSTNAME=$(hostname)
export SERVER_HOSTNAME
TMP=$( hostname -s | awk '{ print substr($0,length,1) }' )
if [ "${TMP}" = "a" ] # the NODE 1 carries adminvhn and is the only one to finish with an 'a'
then
	export NODE="1"
else
	export NODE="2"
fi
NETMASK=$(ifconfig eth0 | grep -E netmask | sed s/'\(.*\)netmask \([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)\(.*\)'/"\2"/g)
export NETMASK
export VIP_NETMASK="255.255.252.0"

export DOMAIN_HOME=/opt/oracle/Middleware/domains/esb_domain   # path to your weblogic domain
export STDOUT_LOGS_DIR=${DOMAIN_HOME}/servers

# Configuration for Dynatrace
export DYNA_SRV_test_1="testdynserver01:9998"
export DYNA_SRV_test_2="testdynserver02:9998"
export DYNA_SRV_PROD_1="prddynserver01:9998"
export DYNA_SRV_PROD_2="prddynserver02:9998"

# the SERVER_HOSTNAME variable will be used to determine which environment it is, this is based on a naming convention -> customize to your environment
SRVNUM="$(( NODE % 2 + 1 ))"
case "$SERVER_HOSTNAME" in
	rh700*)
		ENV=PROD
		eval export DYNA_SRV="\${DYNA_SRV_${ENV}_${SRVNUM}}"
		[ -z "${DYNA_SRV}" ] && echo "Impossible to determine env or node number" && exit 1
		export AGENT_NAME_OSB="prd_OSB"
		export AGENT_NAME_SOA="prd_SOA"
		export AGENT_NAME_WSM="prd_WSM"
		export WLS_AGENT_DYNA_OSB=" -agentpath:/opt/tools/dynatrace_agent/dynatrace_current/agent/lib64/libdtagent.so=name=${AGENT_NAME_OSB},server=${DYNA_SRV} "
		export WLS_AGENT_DYNA_SOA=" -agentpath:/opt/tools/dynatrace_agent/dynatrace_current/agent/lib64/libdtagent.so=name=${AGENT_NAME_SOA},server=${DYNA_SRV} "
		export WLS_AGENT_DYNA_WSM=" -agentpath:/opt/tools/dynatrace_agent/dynatrace_current/agent/lib64/libdtagent.so=name=${AGENT_NAME_WSM},server=${DYNA_SRV} "
		;;
	
	rh680*)
		ENV=REC
		eval export DYNA_SRV="\${DYNA_SRV_${ENV}_${SRVNUM}}"
		[ -z "${DYNA_SRV}" ] && echo "Impossible to determine env or node number" && exit 1
		export AGENT_NAME_OSB="test_OSB"
		export AGENT_NAME_SOA="test_SOA"
		export AGENT_NAME_WSM="test_WSM"
		export WLS_AGENT_DYNA_OSB=" -agentpath:/opt/tools/dynatrace_agent/dynatrace_current/agent/lib64/libdtagent.so=name=${AGENT_NAME_OSB},server=${DYNA_SRV} "
		export WLS_AGENT_DYNA_SOA=" -agentpath:/opt/tools/dynatrace_agent/dynatrace_current/agent/lib64/libdtagent.so=name=${AGENT_NAME_SOA},server=${DYNA_SRV} "
		export WLS_AGENT_DYNA_WSM=" -agentpath:/opt/tools/dynatrace_agent/dynatrace_current/agent/lib64/libdtagent.so=name=${AGENT_NAME_WSM},server=${DYNA_SRV} "
		;;
	
	rh734*)
		ENV=DEV
		export DYNA_SRV=""
		export AGENT_NAME_OSB=""
		export AGENT_NAME_SOA=""
		export AGENT_NAME_WSM=""
		export WLS_AGENT_DYNA_OSB=""
		export WLS_AGENT_DYNA_SOA=""
		export WLS_AGENT_DYNA_WSM=""
		;;
esac

# IP, used for mounting/unmounting VIP and for monitoring
export ADMIN_HOSTNAME=adminvhn									# Admin VIP
export SOA_HOSTNAME=osbhost${NODE}vhn1							# SOA VIP
export OSB_HOSTNAME=osbhost${NODE}vhn2							# OSB VIP
export WSM_HOSTNAME=osbhost${NODE}								# WSM IP, not virtual

# Port numbers, used exclusively for monitoring, we used standard HTTP ports
export NMGR_PORT=5556											# NodeMgr port
export NMGR_ADM_PORT=5557										# Admin NodeMgr port
export ADMIN_PORT=7001											# Admin HTTP port
export SOA_PORT=8001											# SOA HTTP port
export OSB_PORT=8011											# OSB HTTP port
export WSM_PORT=7010											# WSM HTTP port

export NMGR_SERVER_NAME=NodeManager
export ADMIN_SERVER_NAME=AdminServer							# Name of Weblogic Admin Server
export SOA_SERVER_NAME=WLS_SOA${NODE}							# Name of Weblogic SOA Server, differs on each node
export OSB_SERVER_NAME=WLS_OSB${NODE}							# Name of Weblogic OSB Server, differs on each node
export WSM_SERVER_NAME=WLS_WSM${NODE}							# Name of Weblogic WSM Server, differs on each node

export NMGR_CWD=${DOMAIN_HOME}/nodemanager
export NMGR_ADM_CWD=${DOMAIN_HOME}/servers/AdminServer/nodemanager