#!/bin/bash
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
PORT=(3307 3308 3309)
Pid=(`netstat -lntup|grep mysql|awk -F "[/ ]+" '{print $(NF-2)}'`)
COMM="netstat -lntup"
mysql_start=(
"/application/mysql/bin/mysqld_safe --defaults-file=/data/${PORT[0]}/my.cnf"
"/application/mysql/bin/mysqld_safe --defaults-file=/data/${PORT[1]}/my.cnf"
"/application/mysql/bin/mysqld_safe --defaults-file=/data/${PORT[2]}/my.cnf"
)
mysql_kill() {
for n in ${Pid[*]}
do
	for i in ${PORT[*]}
	do
		if [ `netstat -lntup|grep "$i"|wc -l` -eq 1 ];then
			kill $n &>/dev/null
			sleep 2
	 		else
			continue
		fi
	done
	sleep 1
done
}
mysql_restart (){
	for ((z=0;z<${#mysql_start[*]};z++))
	do
		${mysql_start[z]} &>/dev/null &
	sleep 1
	done

}
main (){
mysql_kill
sleep 1
echo "system is trying to restart all mysql service"
sleep 1
mysql_restart
}
main
