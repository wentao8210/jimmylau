#!/bin/bash
[ -f /etc/init.d/functions ] && . /etc/init.d/functions

ROOT_ONLY(){
[ $UID -ne 0 ] && {
echo "Only root can run this script"
exit 1
}
}

Path=/tmp/test
Count=`ls $Path|wc -l`
Del_Comm="find $Path -type f -cmin +5|xargs rm -f"

Monitor(){
/usr/bin/inotifywait -mrq --format '%w%f' -e create,close_write,access,delete,open,move /tmp/test \
|while read file
do
           if [ "$Count" -ge 10 ];then
		find $Path -type f -cmin +2|xargs rm -f
           fi
		
	                TAR=$(ls -lrt $Path|awk 'END{print $NF}')
                cd $Path && tar xf $TAR -C /tmp/123 &>/dev/null
                cat /tmp/123/index.html >/data/8123/index.html
                
done
}

Main(){
ROOT_ONLY
Monitor
}
Main $*
