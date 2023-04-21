#!/bin/bash
#
# Check status of a process: by checking port is open, by checking process is running, or process lock file is present (systemd)
#
# Does not need to source the environment

printUsage()
{
	exit 1
}

# check if process is responding on its IP+PORT
checkServerStatus()
{
	CR=2
	# SERVER_HOSTNAME PORT
	if nc --send-only "$1" "$2" < /dev/null 2> /dev/null  > /dev/null
	then
		CR=0
	else
		CR=1
	fi
	return $CR
}

# check if process is responding on its IP+PORT
checkServerStatusUP()
{
	CR=2
	# SERVER_HOSTNAME PORT
	if nc --send-only "$1" "$2" < /dev/null 2> /dev/null  > /dev/null
	then
		CR=0
	else
		CR=1
	fi
	return $CR
}

# check if a process is started
checkProcessStatus()
{
	CR=2
	if [ $(ps -ef | grep -E "$1" | grep -v grep | grep java | wc -l) -eq "1" ]
	then
		PID=$(ps -ef | grep "$1" | grep -v grep | grep java | awk '{print($2)}')
		CR=0
	else
		CR=1
	fi
	return $CR
}

# check if process has created its working directory (used to monitor node managers)
checkProcessCwdStatus()
{
	# Version specifique avec controle du repertoire d execution du script pour differencier les 2 node manager
	CR=2
	PSNAME=$1
	CWD=$2
	PSCOUNT=0
	
	[ ! -d "$CWD" ] && #echo "Directory $CWD does not exists" && return $CR
	
	for process in $(ps -ef | grep -E "$PSNAME" | grep -v grep | grep java | awk '{print($2)}' | tr "\n" " ")
	do
		ls -ld /proc/${process}/cwd | awk '{print($NF)}' | grep -Ewq "$CWD"
		[ "$?" -eq "0" ] && PSCOUNT=$(( PSCOUNT + 1 ))
	done
	if [ "$PSCOUNT" -ge "1" ]
	then
		CR=0
	else
		CR=1
	fi
	return $CR
}

# color code a return status
checkExitCode()
{
	CR=2
	if [ "$1" -eq "0" ]
	then
		CR=0
	else
		CR=1
	fi
	return $CR
}

