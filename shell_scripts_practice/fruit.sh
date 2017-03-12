#!/bin/bash
[ -f /etc/init.d/functions ]&& . /etc/init.d/functions
RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
PINK_COLOR='\E[1;35m'
RES='\E[0m'
FLASH='\E[31;5m'

cat <<END
1,Apple
2,Orange
3,Pineapple
4,蓝莓
5,Cherry
6,Exit
END
read -t 10 -p "please input one of the num {1|2|3|4|5}: " num
usage() {
    echo -e "${FLASH}Input Error, please input one of the num {1|2|3|4|5}: $RES"
    exit 1
}
color(){
   case $num in 
     1)
    echo -e "${RED_COLOR}Apple$RES"
   ;;
     2)
    echo -e "${GREEN_COLOR}Orange$RES"
   ;;
     3)
    printf "${YELLOW_COLOR}Pineapple$RES"
   ;;
     4)
    printf "${BLUE_COLOR} 蓝莓$RES"
   ;;
     5)
    echo -e "${PINK_COLOR}Cherry$RES"
   ;;
     6)
    exit 6
   ;;
     *)
    usage
   ;;
esac
}
main(){
   color
}
main $*
