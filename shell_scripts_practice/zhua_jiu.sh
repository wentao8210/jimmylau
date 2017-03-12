#!/bin/bash
echo "   #######################################################################################"
echo "   #     企业面试题： 写一个抓阄程序"
echo "   # 要求： 																		"
echo "   # 1、执行脚本后，想去的同学输入英文名字全拼，产生随机数01-99之间的数字， 			"
echo "   # 		  数字越大就去参加项目实践，前面已经抓到的数字，下次不能在出现相同数字。		"
echo "   # 2、第一个输入名字后，屏幕输出信息，并将名字和数字记录到文件里，程序不能退出      "
echo "   #######################################################################################"
echo "   # Script usage :   'quit' to exit shell scripts                         #"
echo "   #######################################################################################"
echo "   #             'sort' to output the order in num file                   #"
echo "   #######################################################################################"
txt=/root/JimmyRobert.txt
touch "$txt"
while true
do
read -p "   #Please input your name by letter: " name
if [ "$name" == "" ];then
    echo "   #WARNING: Username should not empty! "
elif [ "$name" == "quit" ];then
    exit 0
elif [ "$name" == "sort" ];then
  sed 's#^#   &#g' /root/JimmyRobert.txt
elif [ "$name" == "cl" ] || [ "$name" == "clear" ] ;then
  clear
else
    if [ -s "$txt" ];then
    a=`grep -w "$name" "$txt" | wc -l`
    if [ "$a" -gt 0 ];then
      echo "   #WARNING: name as $name is existing"
      echo -n "   ";grep -w "$name" "$txt"
      continue
    else
      declare -i num=$RANDOM%99+1
      b=`grep -w "$num" "$txt" |wc -l`
      if [ "$b" -gt 0 ];then
        continue
      else
        echo -e "$num\t$name">>$txt
        echo -n "   ";grep -w "$name" "$txt"
      fi
    fi
    else
    declare -i num=$RANDOM%99+1
    echo -e "$num\t$name" >>$txt
    echo -n "   ";grep -w "$name" "$txt"
    fi 
  fi
done
