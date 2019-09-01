#!/usr/bin/env bash
#
# Athour: cyylog
# Email: cyylog@aliyun.com
# Date: 2019/04/19
#

 list=(`sudo virsh list --all  | grep "[a-z]"  | awk  '{print $2}'`)
 list1=(`sudo virsh list --all  | grep "[a-z]"  | awk  '{print $3$4}'`)
 unset list[0]
 unset list1[0]
 num=`echo ${#list[@]}`
 for i in `seq  $num`
 do
    a=$(($i))
    if [ "${list1[a]}" == "running" ];then
       Dmac=`sudo virsh dumpxml ${list[a]} |grep 'mac address'|awk -F"'" '{print$2}'`
       IPdate=`arp -a |grep $Dmac | awk -F"(" '{print $2}' | awk -F")" '{print $1}'`
    elif [ "${list1[a]}" == "shutoff" ];then
      sudo virsh start ${list[a]} &>> /dev/null
      wait
      Dmac=`sudo virsh dumpxml ${list[a]} |grep 'mac address'|awk -F"'" '{print$2}'`
      IPdate=`arp -a |grep $Dmac | awk -F"(" '{print $2}' | awk -F")" '{print $1}'`
      sudo virsh shutdown ${list[a]} &>> /dev/null
    fi
    echo "你的第 $i 台虚拟机名字是:${list[a]}   状态为:${list1[a]} 虚拟机IP:$IPdate" 
 done


