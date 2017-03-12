#!/bin/sh

[ $# -ne 1 ] && {
    echo "$0:USAGE:[start|stop|restart|status]"
    exit 4
}

STATUS=0
[ -f /etc/init.d/functions ]&& . /etc/init.d/functions

[ -f /etc/rsyncd.conf ] ||{
    echo "RSYNC CONFIG FILE IS NOT EXITS"
    exit 4
}

status() {
    [ `netstat -lntup|grep rsync|wc -l` -ge 2 ] && {
        echo "rsync is started"
        STATUS=1
    }|| {
        echo "rsync is stop"
        STATUS=0
    }
}


start() {
    status &>/dev/null
    [ $STATUS -eq 0 ] &&{
        rsync --daemon
        if [ $? -eq 0 ];then
            action "RSYNC START OK" /bin/true
            exit 0
        elif [ $? -ne 0 ];then
            action "RSYNC START FALSE" /bin/false
            exit 3
        fi
    }||{
        echo "RSYNC IS STARTED"
        action "RSYNC START FALSE" /bin/false
    }
}

stop() {
    status &>/dev/null
    if [ $STATUS -eq 0 ]; then
        echo "RSYNC IS NOT START"
        action "STOP RSYNC FALSE" /bin/false
    else
        pkill rsync
        sleep 3
        status &>/dev/null
        [ $STATUS -eq 0 ]&&{
            action "RSYNC STOP OK" /bin/true
        }||{
            action "RSYNC STOP FALSE" /bin/false
        }
    fi

}

restart() {
    stop
    start
}

case "$1" in
    start)
        start && exit 0
        ;;
    stop)
        stop || exit 0
        ;;
    restart)
        restart
        ;;
   status)
        status
        ;;
   *)
        echo $"Usage: $0 {start|stop|status|restart}"
        exit 2
esac
