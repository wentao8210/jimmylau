#!/bin/bash
. /etc/init.d/functions
#############Host accessible confirm##############
echo "System is now checking the mysql service ....."
/bin/ping -c2 172.16.1.15 &>/dev/null
[ $? -ne 0 ]&&{
echo "server 172.16.1.15 cannot be accessible"
exit 1
}
sleep 2
###########Variables Setting###########
PATH_3307=/data/3307
PATH_3308=/data/3308
PATH_3309=/data/3309
COMM=/usr/bin/ssh
SSH_PORT=4706
IP=172.16.1.15
MYSQL=`ssh -p 4706 root@172.16.1.15 /bin/netstat -lntup|/bin/grep mysqld|wc -l`
if [ $MYSQL -ne 3 ] ;then
 
   STATUS_3307=`for n in 3307; do nmap -p $n 172.16.1.15|awk 'NR==6{print $2}'; done`
   STATUS_3308=`for n in 3308; do nmap -p $n 172.16.1.15|awk 'NR==6{print $2}'; done`
   STATUS_3309=`for n in 3309; do nmap -p $n 172.16.1.15|awk 'NR==6{print $2}'; done`
############ 3307 judge ################################################

   if [ "$STATUS_3307" = "open" ] ;then
      action " mysql 3307 is running normally..." /bin/true
  else
      action "mysql 3307 is not running..." /bin/false
      sleep 2
      echo "System is now starting 3307..."
      sleep 2
      $COMM -p $SSH_PORT root@$IP $PATH_3307/mysql start &>/dev/null &
      sleep 3
      PID=`/usr/bin/ssh -p $SSH_PORT root@$IP /bin/ps -ef|grep notty|awk 'NR==1{print $2}'`
      $COMM -p $SSH_PORT root@$IP /bin/kill $PID >/dev/null 2>&1
      sleep 2
      action "3307 should be running now, Please double check" /bin/true
      sleep 1
   fi 
      sleep 3

#################### 3308 judge ###################################
#
       if [ "$STATUS_3308" = "open" ] ;then
          action " mysql 3308 is running normally..." /bin/true
            else
          action "mysql 3308 is not running..." /bin/false
          sleep 2
          echo "System is now starting 3308..."
          sleep 2
          $COMM -p $SSH_PORT root@$IP $PATH_3308/mysql start &>/dev/null &
          sleep 3
          PID=`/usr/bin/ssh -p $SSH_PORT root@$IP /bin/ps -ef|grep notty|awk 'NR==1{print $2}'`
          $COMM -p $SSH_PORT root@$IP /bin/kill $PID >/dev/null 2>&1
          sleep 2
          action "3308 should be running now, Please double check" /bin/true
          sleep 1
       fi
####################### 3309 judge #########################################

            if [ "$STATUS_3309" = "open" ] ;then
                 action " mysql 3309 is running normally..." /bin/true
             else
                 action "mysql 3309 is not running..." /bin/false
               sleep 2
                 echo "System is now starting 3309..."
               sleep 2
                 $COMM -p $SSH_PORT root@$IP $PATH_3309/mysql start &>/dev/null &
               sleep 3
             PID=`/usr/bin/ssh -p $SSH_PORT root@$IP /bin/ps -ef|grep notty|awk 'NR==1{print $2}'`
                 $COMM -p $SSH_PORT root@$IP /bin/kill $PID >/dev/null 2>&1
               sleep 2
              action "3309 should be running now, Please double check" /bin/true
               sleep 2
                 echo -e "\n#########################\nMySQL service from $IP ...\n"

################### Final confirm ######################################################
                 $COMM -p $SSH_PORT root@$IP /bin/netstat -lntup|/bin/grep mysqld
               exit 0
            fi
 else
  echo -e "\n################################\n"
  echo -e "All mysql service are up and running ..See below..\n\n######################\n"
  sleep 1
  echo -e "MySQL service from $IP ...\n"
  $COMM -p $SSH_PORT root@$IP /bin/netstat -lntup|/bin/grep mysqld
fi
exit 0
