#!/bin/bash
. /etc/init.d/functions
function menu {
cat <<END
  1,[install LAMP]
  2,[install LNMP]
  3,[eixt]
END
}
menu
read -t 10 -p "pls input num:" num1
if [ $num1 -eq 1 ] ;then
    if [ ! -f /server/scripts/lamp.sh ] ;then
           echo 'echo "LAMP is now installing" ' >>/server/scripts/lamp.sh
           chmod +x /server/scripts/lamp.sh
        /bin/sh /server/scripts/lamp.sh
          sleep 2
        action "lamp scripts has created and it's installed successfully.." /bin/true
        exit 0
        else
         [ -x /server/scripts/lamp.sh ]|| {
         echo "lamp.sh this scripts cannot be executable..but pls wait a moment"
          sleep 1
         echo "System is now granting permission to lamp.sh this scripts.."
         chmod +x /server/scripts/lamp.sh
          sleep 2
         action "The script of lamp.sh is now executable.." /bin/true
        }
        echo "Please wait a moment, system is installing LAMP.."
        /bin/sh /server/scripts/lamp.sh
        sleep 2
        action "LAMP installed successfully.." /bin/true
        exit 0
    fi
fi
[ $num1 -eq 2 ]&& echo "installing LNMP..." && exit 0
[ $num1 -eq 3 ]&& echo "Exit..." && exit 0
echo "Input Error .."
exit 0
