#!/bin/bash
read -t 10 -p "pls input two nums:" num1 num2
#num1 num2 judge
   [ -z "$num1" -o -z "$num2" ] && {
      echo "Pls input two nums"
      exit 1
}
#expr int judge
expr $num1 + $num2 + 1 &>/dev/null
if [ $? -ne 0 ] ;then
   echo "$num1 or $num2 must be int"
   exit 1
 else
a=$num1
b=$num2
[ "$a" -lt "$b" ]&& {
echo "$a is less than $b"
}
[ "$a" -eq $b ]&& {
echo "$a equal to $b"
}
[ "$a" -gt "$b" ] &&{
echo "$a is greater than $b"
}
fi
