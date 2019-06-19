# WLS Systemd Scripts

This project defines scripts for starting and stopping Weblogic servers as systemd on Linux.
It aims at avoiding some unpleasant situations often encountered by Weblogic administrators:
- When the Linux server is started, the WebLogic server does not start
- When the Linux server is shut down, the WebLogic server does not stop neatly

The scripts have been tested with Oracle SOA Suite on Red Hat Enterprise Linux Server release 7.6.
They can be easily customized to your own environment.

## Pre-requisites

For this to run, you will need any Weblogic server installed on a Linux box. We highly recommend that you review and adapt the `esbenv.sh` file, as it contains paths, port numbers, etc. You will also need to customize the service definition and the dependencies to your own Weblogic topology.

## Description

This project is adapted to a typical Oracle SOA Suite cluster: 2 nodes, one with Administration Server, WSM, OSB and SOA
(respectively named Adminserver, WLS_WSM1, WLS_OSB1, WLS_SOA1), the other one with WSM, OSB and SOA (respectively named
WLS_WSM2, WLS_OSB2, WLS_SOA2). The default ports have been used.
Each node has a number at the end of its name in order to determine whether it is 1 or 2.
There are virtual IP addresses (VIP) that are used for each server: `adminserver` for the Adminserver, `osbhost1vhn1`
for WLS_SOA1, `osbhost1vhn2` for WLS_SOA2, `osbhost1vhn2` for WLS_OSB1, `osbhost2vhn2` for WLS_OSB2, `wsmhost1`
for WLS_WSM1, and `wsmhost2` for WLS_WSM2.

There is a separate node manager for the administration server, in order to ease the migration process during a recovery.

Finally, there is a dedicated service for managing the network interface for the VIPs.

## Installation

The process consists in copying files to your servers, register systemd, and voilà!

### 1) Copy files

Two directories are used:
- **/opt/oracle/scripts** for the custom Weblogic scripts: the files must belong to the Weblogic owner on your system 
(in our case it is named `weblogicuser` and it belongs to group `weblogicgroup`), all the *.sh files must have execution
right for both users `weblogicuser` and `root` 
- **/etc/systemd/system** for systemd services: the files must belong to user `root` with execution rights

### 2) Enable the service from systemctl

As a root user, and for each service:

`systemctl enable nodemgr`

If you happen to modifiy any `*.service` file after this point, you will need to use the following command:

`
systemctl daemon-reload
`

### 3) Test

`systemctl start nodemgr`

`systemctl status nodemgr`

`systemctl stop nodemgr`

`systemctl status nodemgr`

## Usage

Every `service*.sh` file is intended to be used as `root`, whereas any other file is intended for `weblogicuser`.

## Documentation

- **adminnodemgr.service**: is the service for dedicated node manager for the admin server. Deploy it only on node 1
- **adminserver.service**: Weblogic Administration Server, only deploy it on node n°1
- **nodemgr.service**: Weblogic Node Manager Service
- **osbserver.service**:  Oracle Service Bus Service
- **soaserver.service**: Oracle SOA Suite Service
- **wlsvip.service**: service that manages the network interfaces (VIPs)

**Notes:** 
- On host 2, remove the dependency between the Admin server and the OSB/SOA/WSM servers
- Here are the dependencies between services:

`wlsvip <- adminnodemgr <- adminserver <- osbserver/soaserver/wsmserver`

`wlsvip <- nodemgr <- osbserver/soaserver/wsmserver`

- **disable_admin_server.sh**: changes the Weblogic Administration Server location
- **enable_admin_server.sh**: same
- **esb_env.sh**: main environment file describing your installation
- **fast_wlst.sh**: script to use `/dev/./urandom` as the random source for Weblogic (makes it start faster on newer instances)
- **manual_sync.sh**: synchronizes files between the nodes for Weblogic Administration Server migration
- **mount_vip.sh**: mounts virtual network interfaces (VIPs)
- **profile**: another environment file dedicated to command aliases
- **purge_logs.sh**: remove the log files 
- **restart_osb.sh**: example script to demonstrate how to start and stop the server. Can be crontab'ed
- **service_mount_vip.sh**: mounts virtual network interfaces (VIPs), run by root
- **service_start_nmgr_adm.sh**: starts the admin node manager, run by root
- **service_start_nmgr.sh**: starts the node manager, run by root
- **service_unmount_vip.sh**: unmounts virtual network interfaces (VIPs), run by root
- **start_nmgr_adm.sh**: starts the admin node manager
- **start_nmgr.sh**: starts the node manager
- **start-wls-server.sh**: starts a Weblogic server passed in argument, e.g.
`./start-wls-server.sh admin`
- **status_nmgr_adm.sh**: monitors the admin node manager (port, process)
- **status_nmgr.sh**: monitors the node manager (port, process)
- **status-wls-server.sh**: monitors a weblogic server passed in argument (port, process)
- **stop_nmgr_adm.sh**: stops the admin node manager
- **stop_nmgr.sh**: stops the node manager
- **stop-wls-server.sh**: stops the Weblogic server passed in argument
- **unmount_vip.sh**: unmounts virtual network interfaces (VIPs)
- wls_functions.sh
- wlst_internal.sh

**Notes:** 
- All log files are redirected to subdirectories of `/var/opt/oracle`
- User `weblogicuser` requires sudo rights for mounting and unmouting network interfaces (which is not required if you
only use the systemd scripts)
- You will need all the Weblogic managed servers to have a `boot.properties` already set up

## Credits

https://middlewaresnippets.blogspot.com/2015/04/weblogic-server-on-linux-7.html

https://www.qualogy.com/techblog/oracle/introducing-weblogic-to-systemd

https://middlewarelive.wordpress.com/2016/10/27/systemctl-for-weblogic-in-rhel7

Prasen Palvankar (Oracle) for sample Weblogic scripts
