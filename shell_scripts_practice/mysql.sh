#!/bin/bash
#MySQL单实例启停脚本
#2016.11.15
#Created by JimmyRobert
#################
RES='\E[0m'
FLASH='\E[31;5m'
uid=`id | cut -d\( -f1 | cut -d= -f2`
#################

[ -f /etc/init.d/functions ] && . /etc/init.d/functions

######## Functions #######
menu(){
cat <<END
start mysql_3307
stop mysql_3307
restart mysql_3307
exit
END
}
######### USAGE ###############
usage(){
  echo -e "${FLASH}Input Error, please input one of {start|stop|restart|exit}: $RES"
  exit 1
}

############### START ############################

START_3307(){
    [ $uid -gt 0 ]&& echo -e "${FLASH}You are not authorized to run this scrips$RES" && exit 4
    echo "System is checking mysql service"
    sleep 2
    if [ `netstat -lntup|grep 3307|wc -l` -eq 1 ]; then
       action "Mysql 3307 already started" /bin/false
       exit 5
      else
local Path=/data/3307/my.cnf
local COMM_START="/application/mysql/bin/mysqld_safe --defaults-file"

      $COMM_START=$Path &>/dev/null &
      sleep 2
      [ `netstat -lntup|grep 3307|wc -l` -eq 1 ] && {
            action "3307 start successfully" /bin/true
            exit 0
        }
    fi
}
############# STOP #############################
STOP_3307(){
    [ $uid -gt 0 ]&& printf "${FLASH}You are not authorized to run this scrips$RES" && exit 4
     echo "System is checking mysql service"
     sleep 2 
local Path=/data/3307/
local User=root
local Pwd=jimmy0410
local COMM_STOP="mysqladmin -u$User -p$Pwd -S $Path/mysql.sock shutdown"
    if [ `ls $Path|grep mysql.sock|wc -l` -eq 0 ] ;then
            action "3307 is not running currently,so unable to stop" /bin/false
      else
    $COMM_STOP &>/dev/null  
            sleep 1
            action "mysql 3307 has been stop"  /bin/true
    fi
}
############## EXIT ###############
EXIT(){
    exit 6
}
CONF(){
    [ ! -f /data/3307/my.cnf ]&& {
        echo "The config file of mysql was not exist, please double check"
        exit 3
      }
}
############### MAIN ####################
main(){
   menu
   echo -e "\n"
   read -t 5 -p "USAGE $0:{start|stop|restart|exit}: " var
   case $var in
      start)
      START_3307
   ;;
      stop)
      CONF
      STOP_3307
   ;;
      restart)
      CONF
      STOP_3307
    echo "system is now trying to restart mysql 3307 service.."
      sleep 1
      START_3307
   ;;
      exit)
      EXIT
   ;;
      *)
      usage
   esac
}
main $*
