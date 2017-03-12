##自动封IP：分析web或应用日志或者网络连接状态封掉垃圾IP
#!/bin/sh
/bin/netstat -na|grep ESTABLISHED|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -rn|head -10|grep -v -E '192.168|127.0'|awk '{if ($2!=null && $1>4) {print $2}}'>/home/shell/dropip
for i in $(cat /home/shell/dropip)
do
        /sbin/iptables -I INPUT -s $i -j DROP
#-m limit --limit 20/min --limit-burst 6
        echo "$i kill at `date`">>/var/log/ddos
done

#!/bin/sh
## search connection established ips
netstat -an |grep EST|awk -F " " '{print $5}' |cut -d ":" -f4 |grep "[0-9]*.[0-9]*.[0-9]*.[0-9]*" |sort  |uniq -c |sort -rn  |head -50 >/home/shell/ip_connection.log
## drop ips
cat /home/shell/ip_connection.log |egrep -v "[a-z][A-Z]*" |egrep -v "202.165|192.168|127.0"|while read line
do
    count=`echo $line|awk '{print $1}'`
    ip=`echo $line|awk '{print $2}'`
    if [ $count -ge 100 ]
      then
         echo "all establish status connection > 100 ip is : $ip"
         echo "apply rule ,drop $ip access 100 !"
         /sbin/iptables -I INPUT 6 -s $ip -p tcp --dport 80  -j  DROP
         /sbin/service iptables save
    fi
done
