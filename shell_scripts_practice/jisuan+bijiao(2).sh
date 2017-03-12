#!/bin/bash
#Variable confirm
read -t 10 -p "pls input two num:" num1 num2
#parameter judge
echo -e "\n###########################\n"
[ -z "$num1" -o -z "$num2" ]&&{
    echo "USAGE $0: num1 or num2 cannot be null"
    exit 1
}
##Expr Judge
expr $num1 + $num2 + 1 &>/dev/null
if [ $? -ne 0 ] ;then
   echo "$num1 or $num2 must be int"
   exit 1
 else
a=$num1
b=$num2
[ "$a" -eq "$b" ]&& echo "$a was equal to $b"
[ "$a" -lt "$b" ]&& echo "$a was less than $b"
[ "$a" -gt "$b" ]&& echo "$a was greater than $b"
echo -e "\n##################################\n"
echo "$a+$b=$(($a+$b))"
echo "$a-$b=$(($a-$b))"
echo "$a*$b=$(($a*$b))"
echo "$a**$b=$(($a**$b))"
  if [ $b -eq 0 ] ;then
     echo "if $b equal zero, then cannot do the division"
     exit 1
   else
     echo "$a/$b=$(($a/$b))"
     echo "$a%$b=$(($a%$b))"
  fi
fi
