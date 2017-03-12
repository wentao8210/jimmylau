#!/bin/bash
#Create by JimmyRobert
#Create Date 2016/12/18
#Contact Email 120848205@qq.com
#Description：According to the web access log, prevent the DDOS attack
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
[ $UID -ne 0 ]&&{
echo "only root can run this scripts"
exit 90
}
########IP BLOCK###############
IP_BLOCK(){
exec </tmp/`date +%F`.log
while read line
do
  IP=`echo $line|awk '{print $1}'`
  COUNT=`echo $line|awk '{print $2}'`
  UNIQ=`iptables -nL|grep "$IP"|wc -l`
 	if [ "$COUNT" -gt 100 -a "$UNIQ" -lt 1 ];then
       iptables -I INPUT -s $IP -j DROP
       echo $IP >>/tmp/ip_$(date +%F).log
    fi
done
}
############# IP DELETE ############
IP_DEL(){
touch /tmp/ip_$(date +%F -d '-1day').log
while read line
do
  ip=`iptables -nL|grep $line|wc -l`
  	if [ "$ip" -ge 1 ];then   
	iptables -D INPUT -s $line -j DROP
    fi
done </tmp/ip_$(date +%F -d '-1day').log
}
######### Main ##########
main (){
if [ $# -ne 1 ];then
echo "USAGE: $0 ARG"
exit 123
fi
awk '{a[$1]++}END{for(n in a)print n,a[n]}' $1 >>/tmp/$(date +%F).log
IP_BLOCK
sleep 5
IP_DEL
}
main $*
