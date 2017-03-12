#!/bin/bash
[ $UID -ne 0 ]&& {
echo "only root can run this script"
exit 1
}
[ -f /etc/init.d/functions ]&& . /etc/init.d/functions
for ((n=1;n<=10;n++))
do
  [ ! -d /tmp/oldboy ] && mkdir -p /tmp/oldboy
touch /tmp/oldboy/`echo $RANDOM|md5sum|cut -c 1-8`_oldboy.html
done
if [ `ls /tmp/oldboy|wc -l` -eq 10 ];then
action "10 RANDOM file created completed" /bin/true
else
action "File create failed" /bin/false
exit 10
fi
