#!/bin/bash
#Create Date 2016/12/07
#Create By JimmyRobert
#Mysql Master-Slave monitor script 
[ -f /etc/init.d/functions ]&& . /etc/init.d/functions
RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
PINK_COLOR='\E[1;35m'
FLASH='\E[31;5m'
RES='\E[0m'
User=root
Pwd=jimmy0410
Email=224737361@qq.com
COMM="netstat -lntup"
PORT=(3307 3308 3309)
Path3307=/data/${PORT[0]}
Path3308=/data/${PORT[1]}
Path3309=/data/${PORT[2]}
TXT=(/tmp/${PORT[0]}.txt /tmp/${PORT[1]}.txt /tmp/${PORT[2]}.txt)
checkDB(){
local Comm="/application/mysql/bin/mysqld_safe --defaults-file"
for n in ${PORT[*]}
do
if [ `$COMM|grep $n|wc -l` -eq 1 ];then 
  echo -e "${GREEN_COLOR}Mysql $n has been started$RES"
  sleep 1
 else 
  echo -e "${YELLOW_COLOR}Mysql $n is not started, pls wait..$RES"
  sleep 1
  echo -e "${BLUE_COLOR}system is now tryting to start mysql $n service$RES"
  $Comm=/data/$n/my.cnf &>/dev/null &
  sleep 1
  action "Mysql $n service has been started" /bin/true
fi
done
}
checkDB
sleep 1
Mysql=(`mysql -u$User -p$Pwd -S $Path3307/mysql.sock -e "show slave status\G"|grep Yes|wc -l` 
`mysql -u$User -p$Pwd -S $Path3308/mysql.sock -e "show slave status\G"|grep Yes|wc -l` 
`mysql -u$User -p$Pwd -S $Path3309/mysql.sock -e "show slave status\G"|grep Yes|wc -l`
)
$COMM
###################################################
usage (){
echo -e "\n${FLASH}$0 {3307|3308|3309|all|exit}$RES"
exit 100
}
check3307(){
    if [ "${Mysql[0]}" -eq 2 ]; then
     action "Master-Slave replication of 3307 is running normally" /bin/true
     echo "Master-Slave replication of 3307 is running normally `date +%F\ %T`" >>/tmp/3307.txt
    else
     action "Master-Slave replication of 3307 failed"  /bin/false
echo  "Replication service of Mysql 3307 was failed,`date +%F\ %T`" >${TXT[0]}
    sleep 1
     /bin/mail -s "Mysql Master-Slave Replication Service Failure" $Email <${TXT[0]}
    sleep 1
    exit 100
    fi
}
check3308(){
    if [ "${Mysql[1]}" -eq 2 ]; then
     action "Master-Slave replication of 3308 is running normally" /bin/true
     echo "Master-Slave replication of 3308 is running normally `date +%F\ %T`" >>/tmp/3308.txt
    else
     action "Master-Slave replication of 3308 failed"  /bin/false
echo  "Replication service of Mysql 3308 was failed,`date +%F\ %T`" >${TXT[1]}
    sleep 1
     /bin/mail -s "Mysql Master-Slave Replication Service Failure" $Email <${TXT[1]}
    sleep 1
    exit 110
    fi
}
check3309(){
    if [ "${Mysql[2]}" -eq 2 ]; then
     action "Master-Slave replication of 3309 is running normally" /bin/true
     echo "Master-Slave replication of 3309 is running normally `date +%F\ %T`" >>/tmp/3309.txt
    else
     action "Master-Slave replication of 3309 failed"  /bin/false
echo  "Replication service of Mysql 3309 was failed,`date +%F\ %T`" >${TXT[2]}
    sleep 1
     /bin/mail -s "Mysql Master-Slave Replication Service Failure" $Email <${TXT[2]}
    sleep 1
    exit 110
    fi
}
main (){
read -t 10 -p "Which DB u wanna check?{3307|3308|3309|all|exit}:" opt
[ -z "$opt" ]&& usage
case $opt in
 3307)
    check3307
    ;;
 3308)
    check3308
    ;;
 3309)
    check3309
    ;;
  all)
    check3307
    check3308
    check3309
    ;;
 exit)
    exit 102
    ;;
 *)
  echo -e "${FLASH}Input Error...$RES"
  exit 101
    ;;
esac
}
main $*
