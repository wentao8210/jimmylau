#!/bin/bash
#Create by JimmyRobert 刘昕蔚
#Create date 2016.11.30
#QQ 120848205
#MySQL 多实例一键分库分表备份
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
USER=root
PWD=jimmy0410
Port=(3307 3308 3309)
########## 给MySQL各个端口赋值 ########
Check_All_DB(){
local Comm="netstat -lntup"
for ((y=0;y<${#Port[*]};y++))
do
	if [ `$Comm|grep ${Port[y]}|wc -l` -ne 1 ];then
       echo "${Port[y]} is not running, please start it first before backup"
		exit 123
	fi
done
}
Check_3307(){
local Comm="netstat -lntup"
    if [ `$Comm|grep ${Port[0]}|wc -l` -ne 1 ];then
       echo "${Port[0]} is not running, please start it first before backup"
        exit 007
    fi
}
Check_3308(){
local Comm="netstat -lntup"
    if [ `$Comm|grep ${Port[1]}|wc -l` -ne 1 ];then
       echo "${Port[1]} is not running, please start it first before backup"
        exit 008
    fi
}
Check_3309(){
local Comm="netstat -lntup"
    if [ `$Comm|grep ${Port[2]}|wc -l` -ne 1 ];then
       echo "${Port[2]} is not running, please start it first before backup"
        exit 009
    fi
}

######### 给多实例端口赋值 ########
SOCKET=(/data/${Port[0]}/mysql.sock
/data/${Port[1]}/mysql.sock
/data/${Port[2]}/mysql.sock
)

####### mysql 登陆命令 #############
MYCMD=("mysql -u$USER -p$PWD -S ${SOCKET[0]}"
"mysql -u$USER -p$PWD -S ${SOCKET[1]}"
"mysql -u$USER -p$PWD -S ${SOCKET[2]}"
)

###### mysqldump 命令 ##########
MYDUMP=("mysqldump -u$USER -p$PWD -S ${SOCKET[0]}"
"mysqldump -u$USER -p$PWD -S ${SOCKET[1]}"
"mysqldump -u$USER -p$PWD -S ${SOCKET[2]}"
)

###### 多实例各自的Databases #############
DB=("`${MYCMD[0]} -e "show databases;"|grep -Ev "^[Da|infor|mysql|perfor]"`"
"`${MYCMD[1]} -e "show databases;"|grep -Ev "^[Da|infor|mysql|perfor]"`"
"`${MYCMD[2]} -e "show databases;"|grep -Ev "^[Da|infor|mysql|perfor]"`"
)

######## 3307 分库分表备份 #########
BACKUP_3307(){
for n in ${DB[0]}
do
  mkdir -p /tmp/${Port[0]}.$n
  TABLE=`${MYCMD[0]} -e "show tables from $n;"|sed 1d`
    for i in $TABLE
    do
    ${MYDUMP[0]} $n $i -E -F -R --single-transaction --master-data=1|gzip >/tmp/${Port[0]}.$n/$i.sql.gz
        [ `ls /tmp/${Port[0]}.$n/$i.sql.gz|wc -l` -eq 1 ]&&{
        action "$i.sql.gz has been backup successfully" /bin/true
        }||{
        action "$i.sql.gz backup failed" /bin/false
        }
    done
done
}

####### 3308 分库分表备份 #########
BACKUP_3308(){
    for n in ${DB[1]}
do
  mkdir -p /tmp/${Port[1]}.$n
  TABLE=`${MYCMD[1]} -e "show tables from $n;"|sed 1d`
    for i in $TABLE
    do
    ${MYDUMP[1]} $n $i -E -F -R --single-transaction --master-data=1|gzip >/tmp/${Port[1]}.$n/$i.sql.gz
        [ `ls /tmp/${Port[1]}.$n/$i.sql.gz|wc -l` -eq 1 ]&&{
        action "$i.sql.gz has been backup successfully" /bin/true
        }||{
        action "$i.sql.gz backup failed" /bin/false
        }
    done
done
}

###### 3309 分库分表备份 ###########
BACKUP_3309(){
    for n in ${DB[2]}
do
  mkdir -p /tmp/${Port[2]}.$n
  TABLE=`${MYCMD[2]} -e "show tables from $n;"|sed 1d`
    for i in $TABLE
    do
    ${MYDUMP[2]} $n $i -E -F -R --single-transaction --master-data=1|gzip >/tmp/${Port[2]}.$n/$i.sql.gz
        [ `ls /tmp/${Port[2]}.$n/$i.sql.gz|wc -l` -eq 1 ]&&{
        action "$i.sql.gz has been backup successfully" /bin/true
        }||{
        action "$i.sql.gz backup failed" /bin/false
        }
    done
done
}

###### main 函数 #########
main (){
read -t 10 -p "which DB you wanna backup?[3307|3308|3309|all]: " num
case $num in 
    3307)
	Check_3307
	sleep 1
    BACKUP_3307
	;;
	3308)
	Check_3308
	sleep 1
	BACKUP_3308
	;;
    3309)
	Check_3309
	sleep 1
	BACKUP_3309
    ;;
    all)
	Check_All_DB
	sleep 1
	BACKUP_3307
	sleep 1
 	BACKUP_3308
	sleep 1
	BACKUP_3309
	;;
	*)
	echo "Input error.."
	echo "USAGE: $0 [3307|3308|3309|all]"
	exit 111
	;;
esac
}
main $*
