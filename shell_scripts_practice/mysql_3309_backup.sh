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
$MYDUMP -B $n -E -F -R --single-transaction --master-data=1|gzip >/tmp/$n.sql.gz
[ ! -z /tmp/$n.sql.gz -a `ls /tmp/$n.sql.gz|wc -l` -eq 1 ]&&{
action "$n.sql.gz has been backup successfully" /bin/true
}||{
action "$n.sql.gz backup failed" /bin/false
}
done

