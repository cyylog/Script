#!/bin/bash
###############################################
#    Desc        ：nginx日志分析脚本          #
#    Author      : cyylog                     #
#    Date        : 2020-06-21                 #
###############################################
public(){
    echo ""
    read -p "请输入要分析的访问日志: " log_file
    echo ""
    if [ ! -f $log_file ];then
        echo "未找到: ${log_file}"
        exit 1
    fi
    if [ ! -s $log_file ];then
        echo "${log_file}是空文件"
        exit 1
    fi
    #输出日志访问量排名前top_num条数据，可自定义 
    top_num=5
    input_file=`echo $log_file | awk -F '/' '{print $(NF)}'`
    analyze_dir=/home/Bertram/`date +%F`
    top_ip_file=$analyze_dir/ngx_log_top_ip_${input_file}.txt
    top_src_url_file=$analyze_dir/ngx_log_top_src_url_${input_file}.txt
    top_dest_url_file=$analyze_dir/ngx_log_top_dest_url_${input_file}.txt
    top_code_file=$analyze_dir/ngx_log_top_code_${input_file}.txt
    top_terminal_file=$analyze_dir/ngx_log_top_terminal_${input_file}.txt
    mkdir -p $analyze_dir
    start_time=`head -1 $log_file | awk '{print $4}'|cut -d "[" -f2`
    end_time=`tail -1 $log_file | awk '{print $4}'|cut -d "[" -f2`
    total_nums=`wc -l $log_file | awk '{print $1}'`
    size=`du -sh $log_file | awk '{print $1}'`
    #获取起始与截止时间
    echo "访问起始时间: $start_time ; 截止时间: $end_time"
    #获取总行数与大小
    echo  "共访问 $total_nums 次 ; 日志大小: $size"
    //以下需根据自己的nginx日志格式来进行截取：
    #获取最活跃IP
    cat $log_file | awk '{print $1}' | sort | uniq -c | sort -rn | head -${top_num} > $top_ip_file
    #获取访问来源最多的url
    cat $log_file | awk '{print $11}' | sort | uniq -c | sort -rn | head -${top_num} > $top_src_url_file
    #获取请求最多的url
    cat $log_file | awk '{print $7}' | sort | uniq -c | sort -rn | head -${top_num} > $top_dest_url_file
    #获取返回最多的状态码
    cat $log_file | awk '{print $9}'| sort | uniq -c | sort -rn | head -${top_num} > $top_code_file
    #获取返回最多的终端类型
    cat $log_file | awk '{print $13}'| sort | uniq -c | sort -rn | head -${top_num} > $top_terminal_file
    }
    simple(){
    echo "+-+-+-+-+-+- 下面是分析内容 +-+-+-+-+-+-"
    #获取最活跃IP
    printf "最活跃的前${top_num}个访问IP: \n"
    cat $top_ip_file
    echo ""
    #获取访问来源最多的url
    printf "访问来源最多的前${top_num}个url: \n"
    cat $top_src_url_file
    echo ""
    #获取请求最多的url
    printf "请求最多的前${top_num}个url: \n"
    cat $top_dest_url_file
    echo ""
    #获取返回最多的状态码
    printf "返回最多的前${top_num}个状态码: \n"
    cat $top_code_file
    echo ""
    printf ""
    #获取返回最多的终端号
    printf "返回最多的前${top_num}个终端号: \n"
    cat $top_terminal_file
    echo ""
    printf ""
    printf "返回最多的前${top_num}个IP所属城市（查询时间有点慢，耐心等待！）: \n"
    echo ''
    printf "%-15s %-15s %-30s\n" "访问次数" "  IP地址" "      归属地"
    echo '-----------------------------------------------'
    a=0
    cat $analyze_dir/ngx_log_top_ip_${input_file}.txt | while read line
    do
    ip=$(echo $line | cut -d ' ' -f2)
    count=$(echo $line | cut -d ' ' -f1)
       printf "%-10s %-15s %-30s\n" $count $ip $(curl -s "http://freeapi.ipip.net/$(echo $line | cut -d ' ' -f2)" | awk -F '\"' {'print $2"--"$4"--"$6'})
    echo '-----------------------------------------------'
    let a=a+1
    done
    echo ""
    printf ""
}
case $1 in
    help)
        echo ""
        echo -e $"Usage: $0 enter a log file \n"
        ;;
    *)
     public
     simple
        ;;
esac
exit 0