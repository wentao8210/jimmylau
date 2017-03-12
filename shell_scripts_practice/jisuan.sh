#!/bin/bash
#Parameter judge
read -t 10 -p "pls input two nums:" a b
[ -z "$a" ] && {
    echo "The first num must be inputed."
    exit 1
}
[ -z "$b" ] && {
    echo "The second num must be inputed"
    exit 1
}
#expr judge
expr $a + $b + 1 &>/dev/null
   if [ $? -ne 0 ] ;then
      echo "$a or $b is not valid"
     exit 1
      else
echo "$a+$b=$(($a+$b))"
echo "$a-$b=$(($a-$b))"
echo "$a*$b=$(($a*$b))"
      if [ $b -eq 0 ];then
        echo " If $b equal zero,then it cannot do the division"
       else
echo "$a/$b=$(($a/$b))"
echo "$a%$b=$(($a%$b))"
      fi
echo "$a**$b=$(($a**$b))"
exit 0
   fi
