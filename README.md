# WLS Systemd Scripts

1) Copy files

2) Enable the service from systemctl
systemctl enable nodemgr
systemctl enable adminserver
systemctl daemon-reload

3) Test
systemctl start nodemgr
systemctl status nodemgr -l

systemctl start adminserver
systemctl status adminserver -l

systemctl stop adminserver
systemctl status adminserver -l

systemctl stop nodemgr
systemctl status nodemgr -l