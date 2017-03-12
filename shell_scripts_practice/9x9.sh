#!/bin/bash
for n in `seq 9`
do
	for i in `seq 9`
	do
		if [ $n -ge $i ] ;then
		echo -ne "${n}x${i}=`echo $(($n*$i))` "
		fi
	done
echo " "
done
