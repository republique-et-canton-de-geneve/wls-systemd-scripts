#!/bin/bash
#
# Unmounts all the min VIP based on which node it is (systemd)

export TERM=dumb

ifconfig | grep -Ewq "^eth0:[0-9]"
if [ "$?" -eq "0" ]
then
	/sbin/ifconfig eth0:1 down 2>/dev/null > /dev/null
	/sbin/ifconfig eth0:2 down 2>/dev/null > /dev/null
	/sbin/ifconfig eth0:3 down 2>/dev/null > /dev/null
fi