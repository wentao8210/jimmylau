#!/bin/bash
function usage() {
echo "Must be 2 variables"
exit 1
}

function color(){

    local STR1="$1"
    local STR2="$2"
    
    printf "\033[31;1m$STR1\n\033[0m"
    printf "\033[33;1m$STR2\033[0m"
  
    return 0
}
RETVAL=$?
main() {
if [ $# -lt 2 ] ;then
   usage
else
   color $1 $2
   return $RETVAL
fi
}
main $*
