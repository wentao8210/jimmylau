#!/bin/bash
SHIT=0

for BITCH in 59{26..50}
do

 	((SHIT++))
echo "KILL $BITCH"
sleep 1
if [ $SHIT -lt 10 ] ;then
echo "start XP0$SHIT"
else
echo "start XP$SHIT"
fi
sleep 1
done
