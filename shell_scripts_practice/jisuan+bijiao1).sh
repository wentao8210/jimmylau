#!/bin/bash

usage(){  
echo "USAGE $0 num1 num2,and both must be int"
exit 1
}

read -t 10 -p "please input two nums: " num1 num2
function numjudge() {
   [ -z "$num1" -o -z "$num2" ]&& {
   usage
  }
}
function intjudge() {
   expr $num1 + $num2 + 1 &>/dev/null
   if [ $? -ne 0 ] ;then
     usage
   fi
}
function daxiao(){
   if [ "$num1" -eq "$num2" ] ; then
      echo "$num1 was equal to $num2"
   elif [ "$num1" -gt "$num2" ] ; then
      echo "$num1 was greater than $num2"
   else
      echo "$num1 was less than $num2"
   fi
}
function calculate() {
   echo "$num1+$num2=$(($num1+$num2))"
   echo "$num1-$num2=$(($num1-$num2))"
   echo "$num1*$num2=$(($num1*$num2))"
   echo "$num1**$num2=$(($num1**$num2))"
   [ $num2 -eq 0 ]&& echo "if 被除数 equal to zero then cannot do the devision"&& exit 1
   echo "$num1/$num2=$(($num1/$num2))"
   echo "$num1%$num2=$(($num1%$num2))"
}

function main() {
  numjudge
  intjudge
  daxiao
  calculate
}
main $*  
