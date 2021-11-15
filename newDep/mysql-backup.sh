#!/usr/bin/env bash

# -----------------------------------------------------------------------------------------------------
# Mysql 备份脚本
# 可以通过 crond 服务，设置称为定时执行脚本：
#   （1）执行 crontab -e 编辑定时执行任务，如：59 23 * * * /home/scripts/mysql-backup.sh
#   （2）vi /etc/crontab，编辑 crontab 文件后保存，可以通过 crontab -l 查看
# @author Zhang Peng
# -----------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------ env
# Mysql Host
export ENV_MYSQL_HOST="127.0.0.1"
# Mysql 端口
export ENV_MYSQL_PORT=3306
# Mysql 用户名
export ENV_MYSQL_USERNAME=root
# Mysql 密码
export ENV_MYSQL_PASSWORD=root
# Mysql 备份文件最大数量
export ENV_BACKUP_MAX_NUM=7
# 备份模式：备份所有数据库（--all-databases）|备份指定数据库列表
export ENV_MYSQL_DATABASES=--all-databases
# 备份路径
export ENV_MYSQL_BACKUP_DIR=/var/lib/mysql/backup
# 备份日志路径
export ENV_LOG_PATH="${ENV_MYSQL_BACKUP_DIR}/mysql-backup.log"

# ------------------------------------------------------------------------------ libs
LINUX_SCRIPTS_LIB_DIR=`dirname ${BASH_SOURCE[0]}`
if [[ ! -x ${LINUX_SCRIPTS_LIB_DIR}/lib/mysql.sh ]]; then
    echo "${LINUX_SCRIPTS_LIB_DIR}/lib/mysql.sh not exists!"
    exit 1
fi
source ${LINUX_SCRIPTS_LIB_DIR}/lib/mysql.sh

# ------------------------------------------------------------------------------ main
# 执行备份方法
backupMysql
