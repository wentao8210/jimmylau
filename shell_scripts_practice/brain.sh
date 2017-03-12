#!/bin/sh
. /etc/init.d/functions
lb01_vip=10.0.0.4
lb01_ip=10.0.0.5
while true
do
ping -c 2 -W 3 $lb01_vip >/dev/null 2>&1
if [ $? -eq 0 ]&&[ `ip add|grep "$lb01_vip"|wc -l` -eq 0 ] ;then
     action " everything is good" /bin/true
     else
     action " split brain warning" /bin/false
     echo "WARNING ~~!!! Split brain for 10.4, please check urgently" >>/home/jimmy/WARNING.txt
     mail -s "WARNING Split brain for 10.4" 13612106754@163.com </home/jimmy/WARNING.txt
     exit
fi
sleep 5
done
