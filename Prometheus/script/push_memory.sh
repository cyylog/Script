#!/bin/bash/env bash
# desc push memory info 
total_memory=`free|awk '/Mem/{print $2}'`
used_memory=`free|awk '/Mem/{print $3}'`

job_name=`custom_memory`
instance_name="192.168.42.153"
cat <<EOF | curl --data-binary @- http://192.168.42.153:9091/metrics/job/$job_name/instance/$instance_name
#TYPE custom_total_memory gauge
custom_memory_ttal $total_memory
#TYPE custom_used_memory gauge
custom_memory_used $used_memory
EOF
