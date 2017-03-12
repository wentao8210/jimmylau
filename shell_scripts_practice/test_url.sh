#!/bin/bash
[ -f /etc/init.d/functions ] && . /etc/init.d/functions

function usage() {
   echo "USAGE $0 url pls"
   exit 1
}

RETVAL=123

CheckUrl() {
local A=`curl -I -s $1|head -1|awk '{print $2}'`
if [ "$A" -eq 200 ] ;then
   action "$1 was accessible" /bin/true
   return $RETVAL
 else
   action "$1 was unaccessible" /bin/false
   return $RETVAL
fi
}

main () {
if [ $# -ne 1 ]; then
  usage
  return $RETVAL
fi
  CheckUrl $1
  return $RETVAL
}

main $*

