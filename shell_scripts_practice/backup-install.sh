#!/bin/sh
#Auth:Role's_Tan
#Mail:847383710@qq.com
#Date:2016-06-06
. /etc/init.d/functions
Hostname=`hostname`
IP=`ifconfig eth0|awk -F "[ :]+" 'NR==2{print $4}'`
Rpm=`rpm -qa nfs-utils rpcbind|wc -l`
M_rw="/data/b_w"
M_ro="/data/b_r"

###
if [ ${Hostname} = backup ]
then
	echo -e "\033[31m Please go to backup server exec!\033[0m"
else
	exit
fi
###mkdir shared directory!
/bin/mkdir -p ${M_rw} || \
/bin/mkdir -p ${M_ro}
######Rsync server file!
	/bin/echo "###rsync server configuration!
#Author: Role's_Tan
#Mail: 847383710@qq.com
#Date: 2016-06-06 15:54
uid = rsync
gid = rsync
user chroot = no
max connections = 200
timeout = 300
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
read only = false
list = false
host allow = 172.16.1.0/24deny 
allow = 0.0.0.0/32
auth user = rsync_backup
secrets file = /etc/rsync.password
###########
[backup]
ignore errors
path = /backup" >/etc/rsyncd.conf &&\
	/usr/sbin/useradd -s /sbin/nologin rsync >/dev/null 2>&1 &&\
	cd / &&\
	/bin/mkdir /backup &&\
	/bin/chown -R rsync.rsync /backup &&\
	echo "rsync_backup:rsync" >/etc/rsync.password &&\
	chmod 600 /etc/rsync.password &&\
	/usr/bin/rsync --daemon >/dev/null 2>/var/log/rsyncd.log
if [ $? = 0 ]
then 
	action " rsync starting is OK! " /bin/true
else
	rm -f /var/run/rsyncd.pid &&
	/usr/bin/rsync --daemon || \
	echo -e "\033[31m Please check configuration!\033[0m"
fi
###
if [ $? = 0 ]
then
	echo -e "\033[32m Rsync starting successful!!!\033
[0m"
else
	echo -e "\033[31m Rsync starting alredy or failed!\033[0m"
fi
###Installing NFS and rpcbind Server!
if [ $Rpm = 2 ]
then
	echo -e "\033[32m NFS and RPCbind already install!\033[0m" &&\
	/etc/init.d/rpcbind start
else
      	yum install -y nfs-utils rpcbind >/dev/null 2>>/tmp/nfs-install.log &&\
	/etc/init.d/rpcbind start
fi
###
if [ $? = 0 ]
then
	action "Starting rpcbind" /bin/true
else
	action "Starting rpcbind,Please check server!" /bi
n/false
	exit
fi
###Mount NFS shared diectory!
	/usr/sbin/showmount -e 172.16.1.31 >/dev/null 2>>/tmp/nfs_mount.log
if [ $? = 0 ]
then
        /bin/mount -t nfs 172.16.1.31:/data/r_shared ${M_ro} ||\
        /bin/mount -t nfs 172.16.1.31:/data/w_shared ${M_rw} 
else
	echo -e "\033[31m Please check NFS and rpcbind server!\033[0m"
	exit
fi

