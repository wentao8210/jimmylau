###compose view server IP
A=eth0
B=eth1
###
for n in 41 8
do
 ssh -p 4706 10.0.0.$n /sbin/ifconfig $A|/bin/awk 'BEGIN{FS="[ :]+"}NR==2{print $4}' $1
done

