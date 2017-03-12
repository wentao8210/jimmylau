#!/bin/bash
. /etc/init.d/functions
########Upload The Following File To /home/wangrubin/tools/###########
#       libiconv-1.14.tar.gz                                         #
#       mysql-5.5.32-linux2.6-x86_64.tar.gz                          #
#       php-5.3.27.tar.gz                                            #
######################################################################
function Compare()
{
if [ $1 $2 $3 ]
     then
        action "$4 is Ok" /bin/true
     else
        action "$4 is Fail" /bin/false
        exit 1
fi
}
#TEST /home/wangrubin/tools File's NUMBER
Filenum=$(ls -l /home/wangrubin/tools/|wc -l)
Compare "$Filenum" "-eq" "4" "File's number"
#NETWORK TEST
NET_A=$(curl -I --connect-timeout 1 -o /dev/null -s -w %{http_code}"\n" www.baidu.com)
NET_B=$(curl -I --connect-timeout 1 -o /dev/null -s -w %{http_code}"\n" www.china.com)
NET_C=$(curl -I --connect-timeout 1 -o /dev/null -s -w %{http_code}"\n" www.sina.com.cn)
((NET=$NET_A+$NET_B+$NET_C))
Compare "$NET" "-ge" "200" "Network Test"
#YUM CONFIG
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo >/dev/null 2>&1
Compare "$?" "-eq" "0" "Config Yum"
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo >/dev/null 2>&1
Compare "$?" "-eq" "0" "Config Epel"
#INSTALL && CONFIG NGINX 
yum install pcre-devel openssl-devel -y >/dev/null 2>&1
useradd nginx -M -s /sbin/nologin
cd /home/wangrubin/tools/
wget -q http://nginx.org/download/nginx-1.6.3.tar.gz >/dev/null 2>&1
Compare "$?" "-eq" "0" "Get nginx-1.6.3.tar.gz"
tar xf nginx-1.6.3.tar.gz >/dev/null 2>&1
cd nginx-1.6.3
./configure --prefix=/application/nginx-1.6.3 --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_status_module >/dev/null 2>&1
make >/dev/null 2>&1 &&\
make install >/dev/null 2>&1 &&\
ln -s /application/nginx-1.6.3/ /application/nginx
/application/nginx/sbin/nginx >/dev/null 2>&1
Code=$(curl -I --connect-timeout 1 -o /dev/null -s -w %{http_code}"\n" 127.0.0.1)
Compare "$Code" "-eq" "200" "Install Nginx"
#VIRTUAL HOST
htmldir=/application/nginx/html/
confdir=/application/nginx/conf/
cat >$confdir/nginx.conf <<END
worker_processes  1;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    include extra/www.conf;
    include extra/bbs.conf;
    include extra/blog.conf;
        include extra/status.conf;
}
END
mkdir -p $confdir/extra
cat >$confdir/extra/www.conf <<END
server {
        listen       80;
        server_name  www.wangrubin.com;
        location / {
            root   html/www;
            index  index.html index.htm;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
END
cat >$confdir/extra/bbs.conf <<END
server {
        listen       80;
        server_name  bbs.wangrubin.com;
        location / {
            root   html/bbs;
            index  index.html index.htm;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
END
cat >$confdir/extra/blog.conf <<END
server {
        listen       80;
        server_name  blog.wangrubin.com;
        location / {
            root   html/blog;
            index  index.html index.htm;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
END
cat >$confdir/extra/status.conf <<END
server {
        listen       80;
        server_name  status.wangrubin.com;
        location / {
                stub_status on;         
        access_log   off;
        }
    }
END
mkdir -p $htmldir/www
mkdir -p $htmldir/bbs
mkdir -p $htmldir/blog
echo "<h1>WWW.WANGRUBIN.COM</h1>"> $htmldir/www/index.html
echo "<h1>BLOG.WANGRUBIN.COM</h1>"> $htmldir/blog/index.html   
echo "<h1>BBS.WANGRUBIN.COM</h1>"> $htmldir/bbs/index.html
#TEST SYNTAX
/application/nginx/sbin/nginx -t 2>Test.txt
NginxTest=$(cat Test.txt)
[[ $NginxTest =~ "test is successful" ]] &&\
/application/nginx/sbin/nginx -s reload
#TEST
Host_IP=$(ifconfig eth0|awk -F "[ :]+" 'NR==2{print $4}')
echo "$Host_IP       www.wangrubin.com       bbs.wangrubin.com       blog.wangrubin.com      status.wangru
bin.com    wangrubin.com" >>/etc/hosts
Code=$(curl -I --connect-timeout 1 -o /dev/null -s -w %{http_code}"\n" www.wangrubin.com)
Compare "$Code" "-eq" "200" "www.wangrubin.com"
Code=$(curl -I --connect-timeout 1 -o /dev/null -s -w %{http_code}"\n" bbs.wangrubin.com)
Compare "$Code" "-eq" "200" "bbs.wangrubin.com"
Code=$(curl -I --connect-timeout 1 -o /dev/null -s -w %{http_code}"\n" blog.wangrubin.com)
Compare "$Code" "-eq" "200" "blog.wangrubin.com"
Code=$(curl -I --connect-timeout 1 -o /dev/null -s -w %{http_code}"\n" status.wangrubin.com)
Compare "$Code" "-eq" "200" "status.wangrubin.com"
cd /home/wangrubin/tools/
#INSTALL MYSQL 
tar xf mysql-5.5.32-linux2.6-x86_64.tar.gz >/dev/null 2>&1
useradd -s /sbin/nologin -M mysql
mv mysql-5.5.32-linux2.6-x86_64 /application/mysql-5.5.32
ln -s /application/mysql-5.5.32/ /application/mysql
/application/mysql/scripts/mysql_install_db --basedir=/application/mysql --datadir=/application/mysql/data/ --user=mysql >/dev/null 2>&1
chown -R mysql.mysql /application/mysql
\cp /application/mysql/support-files/my-small.cnf /etc/my.cnf
sed -i 's#/usr/local/mysql#/application/mysql#g' /application/mysql/bin/mysqld_safe /application/mysql/support-files/mysql.server
\cp /application/mysql/support-files/mysql.server /etc/init.d/mysqld
\cp /application/mysql/bin/* /usr/local/sbin/
/etc/init.d/mysqld start >/dev/null 2>&1
Compare "$?" "-eq" "0" "Install MySQL"
#CONFIG MYSQL_PASSWORD
/usr/local/sbin/mysqladmin -uroot password default@123
#INSTALL PHP
yum install libxml2-devel libjpeg-devel libiconv-devel freetype-devel libpng-devel gd-devel curl-devel libxslt-devel libmcrypt-devel mhash mhash-devel mcrypt -y >/dev/null 2>&1
tar xf libiconv-1.14.tar.gz >/dev/null 2>&1
cd libiconv-1.14
./configure --prefix=/usr/local/libiconv >/dev/null 2>&1
make >/dev/null 2>&1 &&\
make install >/dev/null 2>&1
cd ..
tar xf php-5.3.27.tar.gz >/dev/null 2>&1
cd php-5.3.27
./configure --prefix=/application/php5.3.27 --with-mysql=/application/mysql --with-iconv-dir=/usr/local/libiconv --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --enable-short-tags --enable-zend-multibyte --enable-static --with-xsl --with-fpm-user=nginx --with-fpm-group=nginx --enable-ftp >/dev/null 2>&1
ln -s /application/mysql/lib/libmysqlclient.so.18  /usr/lib64/
touch ext/phar/phar.phar
make >/dev/null 2>&1 &&\
make install >/dev/null 2>&1
ln -s /application/php5.3.27/ /application/php
cp php.ini-production /application/php/lib/php.ini
cd /application/php/etc/
mv php-fpm.conf.default php-fpm.conf
/application/php/sbin/php-fpm >/dev/null 2>&1
Compare "$?" "-eq" "0" "Install PHP"
#TEST NGINX TO PHP
cat >$confdir/extra/blog.conf <<EOF
server {
        listen       80;
        server_name  blog.wangrubin.com;
        root   html/blog;
        location / {
            index  index.html index.htm;
        }
        location ~ .*\.(php|php5)?$
            {
             fastcgi_pass  127.0.0.1:9000;
             fastcgi_index index.php;
             include fastcgi.conf;
           }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
EOF

cat >$htmldir/blog/phpinfo.php <<EOF
<?php
phpinfo();
?>
EOF
/application/nginx/sbin/nginx -s reload
Code=$(curl -I --connect-timeout 1 -o /dev/null -s -w %{http_code}"\n" blog.wangrubin.com/phpinfo.php)
Compare "$Code" "-eq" "200" "Nginx to PHP"
rm -f $htmldir/blog/phpinfo.php
#TEST PHP TO MYSQL
cat >$htmldir/blog/mysql.php <<EOF
<?php
        \$link_id=mysql_connect('localhost','root','default') or mysql_error();
        if(\$link_id){
                echo "mysql successful";
        }else{
                echo "mysql_error()";
        }
?>
EOF
Code=$(curl -I --connect-timeout 1 -o /dev/null -s -w %{http_code}"\n" blog.wangrubin.com/mysql.php)
Compare "$Code" "-eq" "200" "PHP TO MySQL"
rm -f $htmldir/blog/mysql.php
