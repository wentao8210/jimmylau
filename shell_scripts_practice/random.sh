#!/bin/bash
A=(dd3c0 0c1d5 7c52d 4570b 71cad de440 83ede f83ab aa22e 68478)
for n in {0..32767}
do 
   result=`echo $n|md5sum|cut -c 1-5`
	for i in ${A[*]}
    do
       if [ "$i" == "$result" ];then
       echo -e "$n\t$result" 
       fi
    done
done
