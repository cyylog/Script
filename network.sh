#!/bin/bash
#author:yanfei
#date:2019/9/20
#version: v0.2
#QQ:270693833

CRed='\033[1;31m'
CGreen='\033[1;32m'
CYellow='\033[1;33m'
CWhite='\033[1;36m'
CReturn='\033[0m'
DEVICE=$1
AVG_TIME=60
rate_list=./list
DEVICE_LIST=$(ip addr show|grep '^[0-9]'|awk -F '[: ]+' '{print $2}')
[ -e $rate_list ] && rm -f $rate_list
clear
echo -e '\033[?25l'
function unit(){
   local flag transfer 
   flag=$1
   transfer=$2
   if [ $transfer -lt 1024 ];then
      eval ${flag}_rate="${transfer}B/s"
   elif [ $transfer -ge 1024 -a $transfer -lt $((1024*1024)) ];then
#     eval ${flag}_rate="$(echo "scale=1;${transfer}/1024"|bc)KB/s"
      eval ${flag}_rate="$(echo $transfer|awk '{printf "%.1f",$1/1024}')KB/s"
   elif [ $transfer -gt $((1024*1024)) ];then
#     eval ${flag}_rate="$(echo "scale=1;${transfer}/$((1024*1024))"|bc)MB/s"
      eval ${flag}_rate="$(echo $transfer|awk '{printf "%.1f",$1/(1024*1024)}')MB/s"
   fi      
}
function print_rate(){
   local temp1 temp2
   RX_start=$(grep $DEVICE /proc/net/dev | awk '{print $2}')
   TX_start=$(grep $DEVICE /proc/net/dev | awk '{print $10}')
   while :
   do
      RX_pre=$(grep $DEVICE /proc/net/dev | awk '{print $2}')
      TX_pre=$(grep $DEVICE /proc/net/dev | awk '{print $10}')
      sleep 1
      RX_next=$(grep $DEVICE /proc/net/dev | awk '{print $2}')
      TX_next=$(grep $DEVICE /proc/net/dev | awk '{print $10}')
      RX=$((${RX_next}-${RX_pre}))
      TX=$((${TX_next}-${TX_pre}))
      echo "$RX $TX" >> $rate_list
      AVG_RX=$(tail -n $AVG_TIME ${rate_list}| awk '{i++;sum+=$1}END{printf "%d",sum/i}')
      AVG_TX=$(tail -n $AVG_TIME ${rate_list}| awk '{i++;sum+=$2}END{printf "%d",sum/i}')
      RX_total=$((${RX_next}-${RX_start}))
      TX_total=$((${TX_next}-${TX_start}))
      unit RX $RX
      unit TX $TX
      unit AVG_RX ${AVG_RX}
      unit AVG_TX ${AVG_TX}
      temp_RX=$(echo ${RX_total}|awk '{printf "%.1f",$1/(1024*1024)}')MB
      temp_TX=$(echo ${TX_total}|awk '{printf "%.1f",$1/(1024*1024)}')MB
      printf "\033[1H${CYellow}$(date +%T)${CReturn}\n"
      printf "\033[2H${CWhite}%-11s%-17s%-16s%-16s${CReturn}\n" $DEVICE 实时网速 平均网速 积累流量
      printf "\033[3H${CGreen}%-13s${CRed}%-13s%-12s%-16s${CReturn}\n" 下行 ${RX_rate} ${AVG_RX_rate} ${temp_RX}
      printf "\033[4H${CGreen}%-13s${CRed}%-13s%-12s%-16s${CReturn}\n" 上行 ${TX_rate} ${AVG_TX_rate} ${temp_TX}
      trap "echo -e '\033[?25h';exit" INT
   done
}
print_rate