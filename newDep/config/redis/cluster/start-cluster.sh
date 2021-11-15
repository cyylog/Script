#!/usr/bin/env bash

PORT=6380
NODES=6
ENDPORT=$((PORT+NODES))

# 启动 4 个 redis server
while [[ $((PORT < ENDPORT)) != "0" ]]; do
    PORT=$((PORT+1))
    echo "Starting $PORT"
    /opt/redis/src/redis-server /usr/local/redis/conf/${PORT}/redis.conf
done

# 创建集群模式，设置副本为 1
# redis cluster 会自动将 4 个节点设置为 一主一从 模式，并且为两个主节点做数据分片
/opt/redis/src/redis-cli --cluster create 172.22.6.3:6381 172.22.6.3:6382 172.22.6.3:6383 172.22.6.3:6384 172.22.6.3:6385 172.22.6.3:6386 --cluster-replicas 1

# 启动哨兵
/opt/redis/src/redis-sentinel /usr/local/redis/conf/26381/sentinel.conf
/opt/redis/src/redis-sentinel /usr/local/redis/conf/26382/sentinel.conf
/opt/redis/src/redis-sentinel /usr/local/redis/conf/26383/sentinel.conf
