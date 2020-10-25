#!/usr/bin/env bash
#
# Athour: cyylog
# Email: cyylog@aliyun.com
#
# Wechat alert script for zabbix

if [ $# -eq 0 ] || [[ "$1" == "-h" || "$1" == "--help" ]];then
	echo "Usage of $0:"
	echo -e " --CorpID=string"
	echo -e " --Secret=string"
	echo -e " --AgentID=string"
	echo -e " --UserID=string"
	echo -e " --Msg=string"
	exit
fi

#ops=(-c -s -a -u)
#args=(CorpID Secret AgentID UserID)
#while [ $# -gt 0 ];do
#    [ "$1" == "-m" ] && Msg="$2" && shift 2
#    for i in {0..3};do
#        [ "$1" == "${ops[i]}" ] &&  eval ${args[i]}="$2"
#    done
#    shift 2
#done
for i in "$@";do
	echo $i|grep Msg &> /dev/null && msg=$(echo $i|sed 's/.*=//') && Msg="$msg" && continue
	eval "$(echo $i|sed 's/--//')"
done
#echo $CorpID
#echo $Secret
#echo $UserID
#echo $AgentID
#echo $Msg
#
GURL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$CorpID&corpsecret=$Secret"
Token=$(/usr/bin/curl -s -G $GURL |awk -F \" '{print $10}')
PURL="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$Token"
Info(){
	printf '{\n'
	printf '\t"touser": "'"$UserID"\"",\n"
	printf '\t"msgtype": "text",\n'
	printf '\t"agentid": "'"$AgentID"\"",\n"
	printf '\t"text": {\n'
	printf '\t\t"content": "'"$Msg"\""\n"
	printf '\t},\n'
	printf '\t"safe":"0"\n'
	printf '}\n'
}

/usr/bin/curl --data-ascii "$(Info)" $PURL
echo
