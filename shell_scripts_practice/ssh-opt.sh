#!/bin/sh
.   /etc/init.d/functions

echo >/tmp/oldboy.txt
echo "---------selinux optimization start----------" >>/tmp/oldboy.txt
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
setenforce 0
    if [ $? -eq 0 ] ;then
       action "SELINUX optimization" /bin/true >>/tmp/oldboy.txt
    else
       action "SELINUX optimization" /bin/false >>/tmp/oldboy.txt
    fi

    if [[ `getenforce` == 'Disabled' || `getenforce`=='Permissive' ]]
    then
       action "selinux is disabled" /bin/true >>/tmp/oldboy.txt
    else
       action "selinux not's disabled" /bin/false >>/tmp/oldboy.txt
      sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    fi
echo "---------selinux optimization end----------" >>/tmp/oldboy.txt

echo -e "\n\n\n" >>/tmp/oldboy.txt

echo "---------iptables optimization start----------" >>/tmp/oldboy.txt
/etc/init.d/iptables stop >/dev/null 2>&1
/etc/init.d/iptables stop >/dev/null 2>&1
chkconfig iptables off
    if [ $? -eq 0 ] ;then
       action "Iptables is stop" /bin/true >>/tmp/oldboy.txt
    else
       echo -e "iptables not's stop,retrying...\n" >>/tmp/oldboy.txt
       /etc/init.d/iptables stop >/dev/null 2>&1
    if [ $? -eq 0 ] ;then
       action "retrying stop iptables" /bin/true >>/tmp/oldboy.txt
    else
       action "retrying stop iptables" /bin/false >>/tmp/oldboy.txt
    fi
    fi
echo "---------iptables optimization end----------" >>/tmp/oldboy.txt

 echo -e "\n\n\n" >>/tmp/oldboy.txt

echo "---------startup items optimization start----------" >>/tmp/oldboy.txt
chkconfig|egrep -v "crond|sshd|network|rsyslog|sysstat"|awk '{print "chkconfig",$1,"off"}'|bash
a=`chkconfig --list|grep 3:on|wc -l`

    if [ $a == '5' ]
    then
       action "Startup Items is" /bin/true >>/tmp/oldboy.txt
    else
       action "Startup Items is" /bin/false >>/tmp/oldboy.txt
       echo -e "Retrying setting startup items...\n" >>/tmp/oldboy.txt
       chkconfig|egrep -v "crond|sshd|network|rsyslog|sysstat"|awk '{print "chkconfig",$1,"off"}'|bash >>/tmp/oldboy.txt
    if [ $? -eq 0 ] ;then
       action "Retrying setting startup items is " /bin/true >>/tmp/oldboy.txt
    else
       action "Retrying setting startup items is " /bin/false >>/tmp/oldboy.txt
    fi
    fi
echo "---------startup items optimization end----------" >>/tmp/oldboy.txt
