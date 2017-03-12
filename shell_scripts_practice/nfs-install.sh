#!/bin/sh
. /etc/init.d/functions
Hostname=`hostname`
IP=$(ifconfig eth0|awk -F "[ :]+" 'NR==2{print $4}')
Rpm=`rpm -qa nfs-utils rpcbind|wc -l`
###NFS server shared directory.
Ro="/data/w_shared"
Rw="/data/r_shared"
###Change IP address.
if [ ${Hostname} = nfs01 ]
then
	/bin/mkdir -p ${Ro} &&\
	/bin/mkdir -p ${Rw} &&\
	echo "DEVICE=eth1 
	TYPE=Ethernet
	ONBOOT=yes
	BOOTPROTO=static
	IPADDR=172.16.1.31
	NETMASK=255.255.255.0" >/etc/sysconfig/network-scripts/ifcfg-eth1 &&\
	/etc/init.d/network restart >/dev/null 2>&1
else
	exit 
fi
###
if [ $? = 0 ]
then
	chown -R nfsnobody.nfsnobody ${Rw} &&\
	chown -R nfsnobody.nfsnobody ${Ro} &&\
	action " Mkdir directory is OK." /bin/true
else
	action " Mkdir directory is FAILED ro EXIST,Please check." /bin/false
fi
###
if [ ${Rpm} = 2 ]
then
	echo -e "\033[32m NFS and rpcbind already install!\033[0m"
else
	yum install -y nfs-utils rpcbind >/dev/null 2>>/tmp/nfs-install.log
fi
###
if [ $? = 0 ]
then
	echo "${Ro} 172.16.1.0/24(rw,sync,all_squash)" >> /etc/exports &&\
	echo "${Rw} 172.16.1.0/24(ro,sync,all_squash)" >> /etc/exports
else
	exit
fi
###Stating rpcbind and NFS server.
	/etc/init.d/rpcbind start >/dev/null 2>>/tmp/starting.log &&\
	/etc/init.d/nfs start >/dev/null 2>>/tmp/starting.log
###rsync module
	/bin/echo "rsync" >> /etc/rsync.password &&\
	/bin/chmod 600 /etc/rsync.password
###
	/bin/ping -i 1 -I eth1 -c 120 172.16.1.41 >/dev/null 2>&1
if [ $? = 0 ]
then
	/usr/bin/rsync -az /data/ rsync_backup@172.16.1.41::backup/ --password-file=/etc/rsync.password >/dev/null 2>&1
else
	exit
fi
