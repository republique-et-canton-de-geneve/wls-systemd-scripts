#!/bin/bash
#
# Unmounts all the min VIP based on which node it is (command line)

if ! ifconfig | grep -Ewq "^eth0:[0-9]"
then
	sudo /sbin/ifconfig eth0:1 down 2>/dev/null > /dev/null
	echo $?
	sudo /sbin/ifconfig eth0:2 down 2>/dev/null > /dev/null
	echo $?
	sudo /sbin/ifconfig eth0:3 down 2>/dev/null > /dev/null
	echo $?
fi