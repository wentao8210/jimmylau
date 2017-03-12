#./bin/sh
. /etc/init.d/functions
if [ ! -f ~/.ssh ] ;then
/usr/bin/ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa >/dev/null 2>&1
fi
host=`cat /home/jimmy/iplist`
[ ! -f iplist ] && echo "172.16.1.31" >>/home/jimmy/iplist
for n in $host
do
sudo /usr/bin/expect /home/jimmy/expect_jimmy.exp $n >/dev/null 2>&1
if [ $? -eq 0 ] ;then
   action "good job" /bin/true
  else
   action "WTF" /bin/false
fi
done
