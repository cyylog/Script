#!/bin/bash/env bash
cyylog(){
cat <<EOF
	+-------------------------------------------------------+
	|    			Gayhub变绿脚本							|
	|       	1.请自行创建仓库，配置git						|
	|        	2.请自行添加计划任务							|
	|	     	3.若有需求，请自行修改						|
	+-------------------------------------------------------+
EOF
}
echo "初始化中....."
cyylog
filename=$(date +%Y%m%d)_$(date +%H%M%S)
echo `head -c 256 /dev/urandom | od -An -t x | tr -d ' '` >> $filename.txt
git pull origin master;
git add -A;
ss=`date` >/dev/null
# read -p "输入日志,按Enter键跳过 :" log
if  [ ! -n "$log" ] ;then
    git commit -m "${ss}";
else git commit -m "${log} ${ss}";
fi;
git push origin master;
echo "远程推送完成"
