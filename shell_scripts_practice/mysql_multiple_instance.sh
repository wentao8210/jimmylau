#!/bin/bash
[ -f /etc/init.d/functions ]&& . /etc/init.d/functions
[ $UID -ne 0 ]&& echo "only root can run the script" && exit 1
Port=(3307 3308 3309)
User=root
Pwd=jimmy0410
Path=(/data/${Port[0]}/my.cnf /data/${Port[1]}/my.cnf /data/${Port[2]}/my.cnf)
for n in ${Path[*]}
do
if [ `ls "$n"|wc -l` -ne 1 ] ;then
echo "$n does not exist"
exit 10
fi
done
Comm_Path=/application/mysql/bin

MY_START=("${Comm_Path}/mysqld_safe --defaults-file=${Path[0]}" "${Comm_Path}/mysqld_safe --defaults-file=${Path[1]}" "${Comm_Path}/mysqld_safe --defaults-file=${Path[2]}")

MY_STOP=("${Comm_Path}/mysqladmin -u$User -p$Pwd -S /data/${Port[0]}/mysql.sock shutdown"
"${Comm_Path}/mysqladmin -u$User -p$Pwd -S /data/${Port[1]}/mysql.sock shutdown"
"${Comm_Path}/mysqladmin -u$User -p$Pwd -S /data/${Port[2]}/mysql.sock shutdown"
)
COMM="netstat -lntup"
usage(){
echo "USAGE: $0 {1|2|3|4|5|6|7|8}: [select a num between 1~8]"
exit 11
}
Judge(){
RET=$?
if [ "$RET" -eq 0 ];then
action "$1 start successfully" /bin/true
else
action "$1 start failed" /bin/false
fi
return $RET
}
Judge_stop(){
if [ `$COMM|grep $1|wc -l` -eq 0 ];then
   action "$1 was not started, so unable to stop it" /bin/false
fi
}
Start=("${MY_START[0]}"
"${MY_START[1]}"
"${MY_START[2]}"
)
Stop=("${MY_STOP[0]} &>/dev/null"
"${MY_STOP[1]} &>/dev/null"
"${MY_STOP[2]} &>/dev/null"
)
cat <<END
1, 3307 start
2, 3307 stop
3, 3308 start
4, 3308 stop
5, 3309 start
6, 3309 stop
7, Start All DB
8, End All DB
END
read -p "what do u wanna do{1|2|3|4|5|6|7|8}: " num
case "$num" in
 	1)
    if [ `$COMM|grep ${Port[0]}|wc -l` -eq 1 ] ;then
      echo "${Port[0]} already started"
    else
    ${Start[0]} &>/dev/null &
     sleep 1
      Judge 3307
    fi
	;;
	2)
    Judge_stop 3307
	${Stop[0]} &>/dev/null
     sleep 1
	;;
    3)
    if [ `$COMM|grep ${Port[1]}|wc -l` -eq 1 ] ;then
      echo "${Port[1]} already started"
    else
    ${Start[1]} &>/dev/null &
     sleep 1
      Judge 3308
    fi
    ;;
    4)
    Judge_stop 3308
    ${Stop[1]} &>/dev/null
     sleep 1
    ;;
	5)
    if [ `$COMM|grep ${Port[2]}|wc -l` -eq 1 ] ;then
      echo "${Port[2]} already started"
    else
    ${Start[2]} &>/dev/null &
     sleep 1
      Judge 3309
    fi
    ;;
	6)
    Judge_stop 3309
    ${Stop[2]} &>/dev/null
     sleep 1
    ;;
	7)
	for n in ${Port[*]}
    do
      if [ `$COMM|grep $n|wc -l` -eq 1 ];then
        action "$n has been started, so no need to start again" /bin/false && continue
      else
        for ((i=0;i<${#Start[*]};i++))
        do
          ${Start[i]} &>/dev/null &
           sleep 1
        done
      fi
    done
    ;;
	8)
	pkill mysql
	sleep 1
	;;
	*)
	echo "Input error"
     usage
    exit 123
	;;
esac
