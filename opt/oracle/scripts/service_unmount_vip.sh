#!/bin/bash
export TERM=xterm
ifconfig | egrep -wq "^eth0:[0-9]"
if [ "$?" -eq "0" ]
then
	/sbin/ifconfig eth0:1 down 2>/dev/null > /dev/null
	echo $?
	/sbin/ifconfig eth0:2 down 2>/dev/null > /dev/null
	echo $?
	/sbin/ifconfig eth0:3 down 2>/dev/null > /dev/null
	echo $?
fi

