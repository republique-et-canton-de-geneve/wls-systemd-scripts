#!/bin/bash
#
# Unmounts all the min VIP based on which node it is (systemd)
#
# Source the environment
export TERM=xterm

ifconfig | egrep -wq "^ens3:[0-9]"
if [ "$?" -eq "0" ]
then
	/sbin/ifconfig ens3:1 down 2>/dev/null > /dev/null
	echo $?
	/sbin/ifconfig ens3:2 down 2>/dev/null > /dev/null
	echo $?
	/sbin/ifconfig ens3:3 down 2>/dev/null > /dev/null
	echo $?
fi

