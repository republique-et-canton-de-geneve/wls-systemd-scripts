#!/bin/bash

COLOR_RED=`tput setaf 1`
COLOR_GREEN=`tput setaf 2`
COLOR_YELLOW=`tput setaf 3`
COLOR_RESET=`tput sgr0`

printUsage()
{
	echo "Usage: $0 <nmgr|admin|soa|osb|wsm>"
	exit 1
}

checkServerStatus()
{
	CR=2
	# SERVER_HOSTNAME PORT
	if nc --send-only $1 $2 < /dev/null 2> /dev/null  > /dev/null
	then
		echo "${COLOR_GREEN}OK${COLOR_RESET} : Listening on $2"
		CR=0
	else
		echo "${COLOR_RED}KO${COLOR_RESET} : Port closed"
		CR=1
	fi
	return $CR
}

checkServerStatusUP()
{
	# SERVER_HOSTNAME PORT
	if nc --send-only $1 $2 < /dev/null 2> /dev/null  > /dev/null
	then
		echo "UP"
	else
		echo "DOWN"
	fi
}

checkProcessStatus()
{
	CR=2
	if [ `ps -ef | egrep "$1" | grep -v grep | grep java | wc -l` -eq "1" ]
	then
		PID=`ps -ef | grep $1 | grep -v grep | grep java | awk '{print($2)}'`
		echo "${COLOR_GREEN}OK${COLOR_RESET} : Process ${PID}"
		CR=0
	else
		echo "${COLOR_RED}KO${COLOR_RESET} : No process found"
		CR=1
	fi
	return $CR
}

checkProcessCwdStatus()
{
	# Version specifique avec controle du repertoire d execution du script pour differencier les 2 node manager
	CR=2
	PSNAME=$1
	CWD=$2
	PSCOUNT=0
	
	[ ! -d "$CWD" ] && echo "Directory $CWD does not exists" && return $CR
	
	for process in `ps -ef | egrep "$PSNAME" | grep -v grep | grep java | awk '{print($2)}' | tr "\n" " "`
	do
		ls -ld /proc/${process}/cwd | awk '{print($NF)}' | egrep -wq "$CWD"
		[ "$?" -eq "0" ] && PSCOUNT=$(( $PSCOUNT + 1 )) && PID=${process}
	done
	if [ "$PSCOUNT" -ge "1" ]
	then
		echo "${COLOR_GREEN}OK${COLOR_RESET} : Process ${PID}"
		CR=0
	else
		echo "${COLOR_RED}KO${COLOR_RESET} : No process found"
		CR=1
	fi
	return $CR
}

checkExitCode()
{
	if [ "$1" -eq "0" ]
	then
		echo "${COLOR_GREEN}OK${COLOR_RESET}"
	else
		echo "${COLOR_RED}KO${COLOR_RESET}"
	fi
}

