#!/usr/bin/env bash
#
# Author: cyylog
# Email: cyylog@aliyun.com
# Date: 2019/04/19
#

### backup mysql data
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/mysql/bin
d1=`date +%w`
d2=`date +%d`
pass=”your_mysql_password”
bakdir=/bak/mysql
r_bakdir=/backup
echo “mysql backup begin at `date +”%F-%T”`.” >> /log/backup_mysql.log
mysqldump -uroot -p$pass  1000phone >$bakdir/$d1.sql
cp -rf $bakdir/$d1.sql $r_bakdir/$d2.sql
echo “mysql backup end at `date +”%F-%T”`.” >> /log/backup_mysql.log
