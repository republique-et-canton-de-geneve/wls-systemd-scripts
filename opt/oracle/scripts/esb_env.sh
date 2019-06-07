#!/bin/bash
# Sets up the environment for starting and stopping the WLS admin and
# managed servers

export SERVER_HOSTNAME=`hostname`
TMP=`hostname -s`
NODE=`echo ${TMP:(-1)}`

export DOMAIN_HOME=/opt/oracle/Middleware/domains/esb_domain
export STDOUT_LOGS_DIR=/var/opt/oracle
export CONSOLE_PASSWD=install12c

export DYNA_SRV_REC_1="t-dynrec-gva-01.ceti.etat-ge.ch:9998"
export DYNA_SRV_REC_2="t-dynrec-nhp-01.ceti.etat-ge.ch:9998"
export DYNA_SRV_PROD_1="t-dynprod-gva-02.ceti.etat-ge.ch:9998"
export DYNA_SRV_PROD_2="t-dynprod-nhp-02.ceti.etat-ge.ch:9998"
export VIP_NETMASK="255.255.252.0"

# Configuration de l'agent Dynatrace
SRVNUM="$(( $NODE % 2 + 1 ))"
case "$SERVER_HOSTNAME" in
	*prod*)
		ENV=PROD
		eval export DYNA_SRV="\${DYNA_SRV_${ENV}_${SRVNUM}}"
		[ -z "${DYNA_SRV}" ] && echo "Impossible to determine env or node number" && exit 1
		export AGENT_NAME_OSB="prd6683_OSB"
		export AGENT_NAME_SOA="prd6683_SOA"
		export AGENT_NAME_WSM="prd6683_WSM"
		export WLS_AGENT_DYNA_OSB=" -agentpath:/opt/tools/dynatrace_agent/dynatrace_current/agent/lib64/libdtagent.so=name=${AGENT_NAME_OSB},server=${DYNA_SRV} "
		export WLS_AGENT_DYNA_SOA=" -agentpath:/opt/tools/dynatrace_agent/dynatrace_current/agent/lib64/libdtagent.so=name=${AGENT_NAME_SOA},server=${DYNA_SRV} "
		export WLS_AGENT_DYNA_WSM=" -agentpath:/opt/tools/dynatrace_agent/dynatrace_current/agent/lib64/libdtagent.so=name=${AGENT_NAME_WSM},server=${DYNA_SRV} "
		;;
	
	*rec*)
		ENV=REC
		eval export DYNA_SRV="\${DYNA_SRV_${ENV}_${SRVNUM}}"
		[ -z "${DYNA_SRV}" ] && echo "Impossible to determine env or node number" && exit 1
		export AGENT_NAME_OSB="rec6683_OSB"
		export AGENT_NAME_SOA="rec6683_SOA"
		export AGENT_NAME_WSM="rec6683_WSM"
		export WLS_AGENT_DYNA_OSB=" -agentpath:/opt/tools/dynatrace_agent/dynatrace_current/agent/lib64/libdtagent.so=name=${AGENT_NAME_OSB},server=${DYNA_SRV} "
		export WLS_AGENT_DYNA_SOA=" -agentpath:/opt/tools/dynatrace_agent/dynatrace_current/agent/lib64/libdtagent.so=name=${AGENT_NAME_SOA},server=${DYNA_SRV} "
		export WLS_AGENT_DYNA_WSM=" -agentpath:/opt/tools/dynatrace_agent/dynatrace_current/agent/lib64/libdtagent.so=name=${AGENT_NAME_WSM},server=${DYNA_SRV} "
		;;
	
	*dev*)
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

export ADMIN_HOSTNAME=adminserver
export SOA_HOSTNAME=osbhost${NODE}vhn1
export OSB_HOSTNAME=osbhost${NODE}vhn2
export WSM_HOSTNAME=osbhost${NODE}

export NMGR_PORT=5556
export NMGR_ADM_PORT=5557
export ADMIN_PORT=7001
export SOA_PORT=8001
export OSB_PORT=8011
export WSM_PORT=7010

export NMGR_SERVER_NAME=NodeManager
export NMGR_ADM_SERVER_NAME=NodeManager
export ADMIN_SERVER_NAME=AdminServer
export SOA_SERVER_NAME=WLS_SOA${NODE}
export OSB_SERVER_NAME=WLS_OSB${NODE}
export WSM_SERVER_NAME=WLS_WSM${NODE}

export NMGR_CWD=${DOMAIN_HOME}/nodemanager
export NMGR_ADM_CWD=${DOMAIN_HOME}/servers/AdminServer/nodemanager
