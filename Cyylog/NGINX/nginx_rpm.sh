#!/usr/bin/env bash
#
# Athour: cyylog
# Email: cyylog@aliyun.com
# Date: 2019/04/19
# Usage: install nginx web service.
#

sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo sed -ri s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
sudo setenforce 0

# deploy nginx web service action on install before.
sudo yum -y install wget epel-release
sudo yum -y install pcre-devel zlib-devel openssl-devel
sudo yum -y groupinstall "Development Tools"
sudo yum -y install gcc gcc-c++ pcre pcre-devel openssl openssl-devel zlib zlib-devel

sudo groupadd nginx
sudo useradd -M -s /sbin/nologin -g nginx nginx

wget https://nginx.org/download/nginx-1.14.2.tar.gz

# install nginx web service.
sudo tar -vzxf nginx-1.14.2.tar.gz -C /usr/local
cd /usr/local/nginx-1.14.2/
sudo mkdir -p /tmp/nginx/client_body
sudo ./configure  --group=nginx  --user=nginx  --prefix=/usr/local/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf  --error-log-path=/var/log/nginx/error.log  --http-log-path=/var/log/nginx/access.log  --http-client-body-temp-path=/tmp/nginx/client_body  --http-proxy-temp-path=/tmp/nginx/proxy  --http-fastcgi-temp-path=/tmp/nginx/fastcgi  --pid-path=/var/run/nginx.pid  --lock-path=/var/lock/nginx  --with-http_stub_status_module  --with-http_ssl_module  --with-http_gzip_static_module  --with-pcre


sudo make &&make install

sudo /usr/sbin/nginx

