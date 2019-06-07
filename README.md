# WLS Systemd Scripts

This project contains scripts for starting and stopping Weblogic servers as systemd on linux. It has been tested with Oracle SOA Suite on Red Hat Enterprise Linux Server release 7.6. It can easily be customed for your own environment.

## Pre-requisites

For this to run, you will need any Weblogic server installed on a linux box. We higly recommend you review and adapt the esbenv.sh file since it will contain paths, port numbers, etc. You will also need to customize the service definition and dependencies to your custom Weblogic topology.

## Description

This project is adapted to a typical Oracle SOA Suite cluster: 2 nodes, one with Administration Server, WSM, OSB and SOA (respectly named Adminserver, WLS_WSM1, WLS_OSB1, WLS_SOA1), the other with WSM, OSB and SOA (respectly named WLS_WSM2, WLS_OSB2, WLS_SOA2). The default port have been used. Each node has a number at the end of its name to determine wether it is 1 or 2. There are virtual IP addresses (VIP) that are used for each server: adminserver for the Adminserver, osbhost1vhn1 for WLS_SOA1, osbhost1vhn2 for WLS_SOA2, osbhost1vhn2 for WLS_OSB1, osbhost2vhn2 for WLS_OSB2, wsmhost1 for WLS_WSM1, and wsmhost2 for WLS_WSM2.

There is a separate node manager for the administration server in order to ease the migration process during a recovery.

Finally, there is a dedicated service for managing network interface for the VIPs.

## Installation

The process consist of copying files to your servers, register systemd, and voila!

### 1) Copy files

We will use 2 directories:
- **/opt/oracle/scripts** for our custom Weblogic scripts: the files must belong to the Weblogic owner on your system (in our case it is name weblogicuser and belongs to the weblogicgroup), all the *.sh files must have execution right for both weblogicuser and root 
- **/etc/systemd/system** for systemd services: the files must belong to root user with execution rights

### 2) Enable the service from systemctl

A a root user, and for each service:

`systemctl enable nodemgr`

If you happen to modifiy any *.service file after this point, you will need to use the command:
systemctl daemon-reload

### 3) Test
`systemctl start nodemgr`

`systemctl status nodemgr`

`systemctl stop nodemgr`

`systemctl status nodemgr`

## Usage

Every service*.sh file is intended to use as root, every other is for weblogicuser.

## Documentation

- **adminnodemgr.service** : this is the service for dedicated node manager for the admin server, only deploy it on node n°1
- **adminserver.service** : Weblogic Administration Server, only deploy it on node n°1
- **nodemgr.service** : Weblogic Node Manager Service
- **osbserver.service** :  Oracle Service Bus Service
- **soaserver.service** : Oracle SOA Suite Service
- **wlsvip.service** : this is the service that manages the network interfaces (VIPs)

**Notes:** 
- On host n°2, remove the dependency between Admin server and OSB/SOA/WSM servers
- Here are the dependencies between services:

`wlsvip <- adminnodemgr <- adminserver <- osbserver/soaserver/wsmserver`
`wlsvip <- nodemgr <- osbserver/soaserver/wsmserver`

- **disable_admin_server.sh** : use it to change the Weblogic Administration Server location
- **enable_admin_server.sh** : same
- **esb_env.sh** : the main environment file describing your installation
- **fast_wlst.sh** : a script to use /dev/./urandom as the random source for Weblogic (makes it start faster on newer instances)
- **manual_sync.sh** : synchronizes files between the nodes for Weblogic Administration Server migration
- **mount_vip.sh** : mounts virtual network interfaces (VIPs)
- **profile** : another environment file dedicated to command aliases
- **purge_logs.sh** : remove the log files 
- **restart_osb.sh** : an example script for how to start and stop the server, and that you can crontab
- **service_mount_vip.sh** : mounts virtual network interfaces (VIPs), run by root
- **service_start_nmgr_adm.sh** : starts the admin node manager, run by root
- **service_start_nmgr.sh** : starts the node manager, run by root
- **service_unmount_vip.sh** : unmounts virtual network interfaces (VIPs), run by root
- **start_nmgr_adm.sh** : starts the admin node manager
- **start_nmgr.sh** : starts the node manager
- **start-wls-server.sh** : starts a weblogic server passed in argument, eg.
`./start-wls-server.sh admin`
- **status_nmgr_adm.sh** : monitors the admin node manager (port, process)
- **status_nmgr.sh** : monitors the node manager (port, process)
- **status-wls-server.sh** : monitors a weblogic server passed in argument (port, process)
- **stop_nmgr_adm.sh** : stops the admin node manager
- **stop_nmgr.sh** : stops the  node manager
- **stop-wls-server.sh** : stops a weblogic server passed in argument
- **unmount_vip.sh** : unmounts virtual network interfaces (VIPs)
- wls_functions.sh
- wlst_internal.sh

**Notes:** 
- All log files are redirected to directories under /var/opt/oracle
- The weblogicuser requires sudo rights for mounting/unmouting network interfaces (which is not required if you only use the systemd scripts)
- You will need all the Weblogic managed servers to have a boot.properties already working

## Credits

https://middlewaresnippets.blogspot.com/2015/04/weblogic-server-on-linux-7.html
https://www.qualogy.com/techblog/oracle/introducing-weblogic-to-systemd
https://middlewarelive.wordpress.com/2016/10/27/systemctl-for-weblogic-in-rhel7
Prasen Palvankar (Oracle) for sample Weblogic scripts