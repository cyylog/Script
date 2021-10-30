#!/usr/bin/env bash
#
# Athour: cyylog
# Email: cyylog@aliyun.com
# Date: 2019/04/19
#

systemctl stop firewalld
systemctl disable firewalld
sed -ri s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
setenforce 0

curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
yum clean all
yum makecache fast

yum install -y wget ntpdate net-tools vim bash-completion ShellCheck iftop sar htop 
ntpdate -b ntp1.aliyun.com

