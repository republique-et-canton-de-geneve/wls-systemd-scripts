#!/bin/bash
systemctl stop wlsvip

/opt/oracle/scripts/purge_logs.sh

systemctl start osbserver
systemctl start soaserver
systemctl start wsmserver
