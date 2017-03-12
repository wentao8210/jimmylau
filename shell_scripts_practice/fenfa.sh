#!/bin/sh
. /etc/init.d/functions
if [ $# -ne 1 ] ;then
   echo "There should be a filename after $0"
   exit 1
fi
for n in 41 8 7
do
   echo "=====172.16.1.$n========"
   rsync -az -e 'ssh -p 4706' $1 jimmy@172.16.1.$n:~/ >/dev/null 2>&1
   if [ $? -eq 0 ] ;then
   action "transmit completed and all is good" /bin/true
  # echo "transmit completed and all is good"
   else
  # echo "WTF??? trasmit failed"
  action "WTF??? trasmit failed" /bin/false
   fi
done 
