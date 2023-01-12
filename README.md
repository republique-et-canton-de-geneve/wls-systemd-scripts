# WLS Systemd Scripts

This project defines scripts for starting and stopping Weblogic as systemd services on Linux (or from the command line via cron task or a scheduler).
It aims at avoiding some unpleasant situations often encountered by Weblogic administrators:
- When the Linux server is started, the WebLogic server does not start automatically
- When the Linux server is shut down, the WebLogic server does not stop neatly

The scripts have been tested with Oracle Service Bus and Oracle SOA Suite on Red Hat Enterprise Linux Server release 8.6.
They can be easily customized to your own environment.

## Pre-requisites

For this to run, you will need any Weblogic server installed on a Linux box. We highly recommend that you review and adapt the `esbenv.sh` and the `profile` files, as they contains paths, port numbers, etc. You will also need to customize the service definition and the dependencies to your own Weblogic topology.

You also have to resolve all aliases that are listed in the `hosts` sample file.

## Description

This project is adapted to a typical Oracle SOA Suite cluster: 2 nodes, one with Administration Server, WSM, OSB and SOA
(respectively named Adminserver, WLS_WSM1, WLS_OSB1, WLS_SOA1), the other one with WSM, OSB and SOA (respectively named
WLS_WSM2, WLS_OSB2, WLS_SOA2). The default ports have been used.
Each node is identified by an environment variable NODE equal to 1 (where the admin server is) or 2 (on the other server).
There are virtual IP addresses (VIP) that are used for each server: `adminvhn` for the Adminserver, `osbhost1vhn1`
for WLS_SOA1, `osbhost1vhn2` for WLS_SOA2, `osbhost1vhn2` for WLS_OSB1, `osbhost2vhn2` for WLS_OSB2, `osbhost1`
for WLS_WSM1, and `osbhost2` for WLS_WSM2 (actually wsmhost1 and wsmhost1 route to the ens3 network interface of each server respectively)

There is a separate node manager for the administration server listening on the AdminServer VIP, in order to ease the migration process during a recovery. This is not mandatory and you can safely ignore the start/stop/status/service files for this service if you whish to rely on the Oracle standard.

Finally, there is a dedicated systemd service for managing the network interface for all the VIP.

## Installation

The process consists in copying files to your servers, register systemd, and voilà!

### 1) Copy files

Two directories are used:
- **/opt/oracle/scripts** for the custom Weblogic scripts: the files must belong to the Weblogic owner on your system 
(in our case it is named `weblogicuser` and it belongs to group `weblogicgroup`), all the *.sh files must have execution
right for both users `weblogicuser` and `root` for systemd commands
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

- **adminnodemgr.service**: is the service for dedicated node manager for the Adminserver. Deploy it exclusively on node 1
- **adminserver.service**: Weblogic Admin Server, also deploy it exclusively on node 1
- **nodemgr.service**: Weblogic Node Manager Service
- **osbserver.service**:  Oracle Service Bus Service
- **soaserver.service**: Oracle SOA Suite Service
- **wsmserver.service**: WSM Service
- **wlsvip.service**: service that manages the virtual network interfaces (VIP)

**Notes:** 
- On host 2, remove the dependency between the Admin server and the OSB/SOA/WSM servers
- Here are the dependencies between services:

`wlsvip <- adminnodemgr <- adminserver <- osbserver/soaserver/wsmserver`

`wlsvip <- nodemgr <- osbserver/soaserver/wsmserver`

- **esb_env.sh**: main environment file describing your installation -> customize to your environment
- **profile**: should be part for of your weblogic user profile      -> customize to your environment
- **wls_functions.sh**: internal functions used to monitor processes
- **enable_admin_server.sh**: used to change the Weblogic Administration Server location
- **disable_admin_server.sh**: same
- **mount_vip.sh**: mounts virtual network interfaces (VIPs)
- **purge_logs.sh**: remove the old log files 
- **restart_osb.sh**: example script to demonstrate how to start and stop the server. Can be crontab'ed
- **service_mount_vip.sh**: mounts virtual network interfaces (VIPs), run by root
- **service_start_nmgr_adm.sh**: starts the admin node manager, run by root
- **service_start_nmgr.sh**: starts the node manager, run by root
- **service_unmount_vip.sh**: unmounts virtual network interfaces (VIPs), run by root
- **start_nmgr_adm.sh**: starts the admin node manager
- **start_nmgr.sh**: starts the node manager
- **start-wls-server.sh**: starts a Weblogic server passed in argument, e.g. `./start-wls-server.sh admin`
- **status_nmgr_adm.sh**: monitors the admin node manager (port, process)
- **status_nmgr.sh**: monitors the node manager (port, process)
- **status-wls-server.sh**: monitors a weblogic server passed in argument (port, process)
- **stop_nmgr_adm.sh**: stops the admin node manager
- **stop_nmgr.sh**: stops the node manager
- **stop-wls-server.sh**: stops the Weblogic server passed in argument
- **unmount_vip.sh**: unmounts virtual network interfaces (VIPs)


**Notes:** 
- All log files are redirected to subdirectories of `/var/opt/oracle/<Server Name>`
- User `weblogicuser` requires sudo rights for mounting and unmouting network interfaces (which is not required if you
only use the systemd scripts)
- You will need all the Weblogic managed servers to have a `boot.properties` already set up

## Credits

- https://middlewaresnippets.blogspot.com/2015/04/weblogic-server-on-linux-7.html
- https://www.qualogy.com/techblog/oracle/introducing-weblogic-to-systemd
- https://middlewarelive.wordpress.com/2016/10/27/systemctl-for-weblogic-in-rhel7
- Prasen Palvankar (Oracle) for sample Weblogic scripts
