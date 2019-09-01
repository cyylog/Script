#!/usr/bin/env bash
#
# Author: cyylog
# Email: cyylog@aliyun.com
# Date: 2019/04/19
#

Mysql_c="mysql -uroot -p123456"
$Mysql_c -e "show processlist" >/tmp/mysql_pro.log 2>/tmp/mysql_log.err
n=`wc -l /tmp/mysql_log.err|awk '{print $1}'`


if [ $n -eq 1 ]
then
  echo "mysql service sth wrong."
else
  $Mysql_c -e "show slave status\G" >/tmp/mysql_s.log
  n1=`wc -l /tmp/mysql_s.log|awk '{print $1}'`
  
   if [ $n1 -gt 0 ]
   then
     y1=`grep 'Slave_IO_Running:' /tmp/mysql_s.log|awk -F : '{print $2}'|sed 's/ //g'`
     y2=`grep 'Slave_SQL_Running:' /tmp/mysql_s.log|awk -F : '{print $2}'|sed 's/ //g'`
     
     if [ $y1 == "Yes" ] && [ $y2 == "Yes" ]
     then
       echo "slave status good."
     else
       echo "slave down."
     fi


   fi

fi




