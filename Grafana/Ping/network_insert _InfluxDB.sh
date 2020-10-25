#!/usr/bin/env bash
# 
# Date: 2020/10/25
# Author: cyylog
# MyBlog: https://cyylog.netlify.app
# Email: cyylog@aliyun.com
#
# Usage: Insert data into influxdb.
# Monitor ping packet loss and delay.


declare -A dic
influxdb_ip="192.168.42.141"
port=8086

dic=([VN]="192.168.42.2" [ID]="192.168.42.1" [BR]="192.168.42.141" )  #字典

for key in $(echo ${!dic[*]});do
    ping -fc10 ${dic[$key]} > /tmp/ping_result/ping${key}log
    b=`cat /tmp/ping_result/ping${key}log |grep packet|awk -F "," '{print $3}'|awk -F "%" '{print $1}'|sed 's/^[ \t]*//g'`
    c=`cat /tmp/ping_result/ping${key}log  |grep rtt |awk -F',' '{print $1}' |awk -F'=' '{print $2}' |cut -d'/' -f2`

    curl -i -X POST "http://$influxdb_ip:${port}/write?db=network" -u network:network --data-binary "SG_${key}loss loss=$b"
    curl -i -X POST "http://$influxdb_ip:${port}/write?db=network"  -u network:network  --data-binary "SG_${key}laten laten=$c"

done
