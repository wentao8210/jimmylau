#!/bin/bash
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
USER=root
PWD=jimmy0410
Port=(3307 3308 3309)
[ `netstat -lntup|grep ${Port[2]}|wc -l` -ne 1 ] &&{
echo "Mysql ${Port[2]} was not running"
exit 123
}
SOCKET3307=/data/${Port[0]}/mysql.sock
SOCKET3308=/data/${Port[1]}/mysql.sock
SOCKET3309=/data/${Port[2]}/mysql.sock
MYCMD="mysql -u$USER -p$PWD -S $SOCKET3309"
MYDUMP="mysqldump -u$USER -p$PWD -S $SOCKET3309"
DB=`$MYCMD -e "show databases;"|grep -Ev "^[Da|infor|mysql|perfor]"`
for n in $DB
do
  mkdir -p /tmp/$n
  TABLE=`$MYCMD -e "show tables from $n;"|sed 1d`
	for i in $TABLE
    do
    $MYDUMP $n $i -E -F -R --single-transaction --master-data=1|gzip >/tmp/$n/$i.sql.gz
		[ `ls /tmp/$n/$i.sql.gz|wc -l` -eq 1 ]&&{
		action "$i.sql.gz has been backup successfully" /bin/true
		}||{
		action "$i.sql.gz backup failed" /bin/false
		}
 	done
done

