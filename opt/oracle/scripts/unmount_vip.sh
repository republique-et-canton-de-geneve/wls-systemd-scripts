#!/bin/bash
#
# Unmounts all the min VIP based on which node it is (command line)
#
# Source the environment
ifconfig | egrep -wq "^ens3:[0-9]"
if [ "$?" -eq "0" ]
then
	sudo /sbin/ifconfig ens3:1 down 2>/dev/null > /dev/null
	echo $?
	sudo /sbin/ifconfig ens3:2 down 2>/dev/null > /dev/null
	echo $?
	sudo /sbin/ifconfig ens3:3 down 2>/dev/null > /dev/null
	echo $?
fi

