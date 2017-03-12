#!/bin/bash
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
########################################################
usage(){
   echo -e "${FLASH}msg cannot be null$RES"
   exit 100
}
TOP_UP_JUDGE(){
   expr $1 + 1 &>/dev/null
   if [ $? -ne 0 ] ;then
   return 102
   fi
   return 0
}

echo -e "${BLUE_COLOR}This scripts is kind of msg top up similartor\nPlease top up when rest FEE not enough!$RES"
sleep 1
TOTAL=500
R_FEE=250
while [ "$TOTAL" -ge "$R_FEE" ]
do
    read -t 10 -p "Please input your msg here: " msg
    [ -z "$msg" ]&& usage
    read -p "Are you sure to send out this msg?{y|n} " opt
    case $opt in
       [yY]|[yY][eE][sS])
         echo -e "${PINK_COLOR}message sending...$RES"
         sleep 2
         echo -e "${GREEN_COLOR}Message has been sent$RES"
         sleep 1
         ((TOTAL-=R_FEE))
         echo -e "Now, you still have ${RED_COLOR}$TOTAL$RES money rest"
       ;;
        [nN]|[nN][oO])
         echo -e "${RED_COLOR}Msg has been canceled$RES "
         exit 101
       ;;
         *)
          echo -e "${FLASH}Input Error..$RES"
          exit 110
       ;;
    esac
        while [ $TOTAL -lt $R_FEE ]
        do
          sleep 1
      echo -e "${YELLOW_COLOR}$TOTAL money rest,due to ${RED_COLOR}250${YELLOW_COLOR} per once,please top up$RES"
          sleep 1
          read -t 10 -p "Do you wanna top up ur mobile?{y|n} " opt2
              case $opt2 in
                [yY]|[yY][eE][sS])
                  read -p "How much you wanna top up?pls input here: " TOP
                  [ -z "$TOP" ]&& echo -e "${FLASH}Invaild input, cannot be null$RES" && exit 130
                  TOP_UP_JUDGE $TOP && {
                    ((TOTAL+=TOP))
                    if [ "$TOTAL" -lt 250 ] ;then
                      echo -e "${FLASH}You only have ${RED_COLOR}$TOTAL money which is not enough to send out the mesg due to ${YELLOW_COLOR}250 per once$RES"
                      exit 104
                    else
                       sleep 1
                       action "TOP UP successfully" /bin/true
                       echo -e "${PINK_COLOR}Now, you have ${RED}$TOTAL money$RES"
                       break
                    fi
                    }||{
                      echo -e "${FLASH}TOP UP NUM MUST BE INT$RES"
                      exit 129
                    }
                ;;
                [nN]|[nN][oO])
                  exit 5
                ;;
                *)
                  echo -e "${FLASH}Input Error..$RES"
                  exit 6
                ;;
               esac
        done
done 
