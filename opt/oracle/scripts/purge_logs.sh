#/bin/bash

for i in `find /var/opt/oracle -type d -name 'WLS*'`; do cd $i; rm *.log* *.out* *diagnostic-*log; done
for i in `find /var/opt/oracle -type d -name 'Admin*'`; do cd $i; rm *.log* *.out* *diagnostic-*log; done

for i in `find /var/opt/oracle -type d -name metrics`; do cd $i; rm *.log.gz; done

