#!/bin/bash
#Create by JimmyRobert
#2016.11.18
#Email: 120848205@qq.com
#Name of the scripts:手机充值模拟
#############################
TOTAL=500
R_FEE=250
RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
PINK_COLOR='\E[1;35m'
FLASH='\E[31;5m'
RES='\E[0m'
[ -f /etc/init.d/functions ]&& . /etc/init.d/functions
#########################################################
INT_JUDGE(){
  expr $1 + 1 &>/dev/null
  if [ $? -ne 0 -a "$1" != "-1" ] ;then
     return 1
  fi
     return 0
}

while [ $TOTAL -ge $R_FEE ]
do
      read -t 10 -p "Please input you msg here: " msg
      [ -z "$msg" ]&& echo -e "${FLASH}Message cannot be null" && exit 108
      read -p "Are you sure you want to send this message?{y|n}" opt
       case $opt in
           [yY]|[yY][eE][sS])
               echo "Message sending.."
               sleep 2
               echo -e "${GREEN_COLOR}message has been delivered$RES"
               sleep 1
               ((TOTAL-=R_FEE))
               echo -e "Now,you have ${RED_COLOR}$TOTAL$RES money rest"
           ;;
           [nN]|[nN][oO])
               echo -e "${RED_COLOR}Message has been cancel$RES"
               exit 1
           ;;
            *)
               echo -e "${FLASH}Input error..$RES" && exit 100
           ;;    
       esac
         if [ $TOTAL -lt $R_FEE ] ;then
             echo -e "${PINK_COLOR}you have ${RED_COLOR}$TOTAL ${PINK_COLOR}rest,Insufficient balance...!!$RES"
             sleep 1
             read -t 10 -p  "Do you want to Top Up?{y|n}" choose
                    
                case $choose in
                  [yY]|[yY][eE][sS])
                      while true 
                      do
                        read -p "How much you wanna top up? Please input a integer here: " num
                      [ -z "$num" ]&& echo -e"${FLASH}Input Error,Charge cannot be null $RES" && exit 105
                        INT_JUDGE $num && break || {
                        echo -e "${FLASH}Invalid input of the charge..$RES"
                        exit 101
                        }
                      done
                   let TOTAL=$TOTAL+$num
                         if [ $TOTAL -lt 250 ] ;then
 printf "${FLASH}Due to 250 per once,so now still insufficient money to send out the msg, please top up again$RES"
                         exit 110
                         else
                           action "TOP UP has been completed" /bin/true
                           sleep 2
                         fi
                      ;;
                  [nN]|[nN][oO])
                      exit 102
                      ;;
                    *)
                      echo -e "${FLASH}Invalid input..$RES"
                      exit 103
                      ;;
                esac
          fi
done
