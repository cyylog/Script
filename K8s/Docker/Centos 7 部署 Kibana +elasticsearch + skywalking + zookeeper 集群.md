# Centos 7 部署 Kibana +elasticsearch + skywalking + zookeeper 集群

[![img](https://upload.jianshu.io/users/upload_avatars/15537910/e263be16-d8a7-4d13-8a8a-dc64ac68c4af.jpg?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96/format/webp)](https://www.jianshu.com/u/bf0c87ff120e)

[HaoDongZ](https://www.jianshu.com/u/bf0c87ff120e)关注

0.5172021.01.14 10:17:35字数 171阅读 1,220

![img](https://upload-images.jianshu.io/upload_images/15537910-a19202ee2e264473.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

架构图.png



```bash
#官网下载软件包
ElasticSearch-6.8.0: https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.8.0.tar.gz
Kibana-6.8.0:https://artifacts.elastic.co/downloads/kibana/kibana-6.8.0-linux-x86_64.tar.gz
wget  https://mirror.bit.edu.cn/apache/skywalking/8.3.0/apache-skywalking-apm-8.3.0.tar.gz
 wget https://mirrors.bfsu.edu.cn/apache/zookeeper/zookeeper-3.5.8/apache-zookeeper-3.5.8-bin.tar.gz
JDK1.8 : http://www.oracle.com/technetwork/java/javase/downloads
```

# 导入配置环境变量



```bash
vim /etc/profile
export JAVA_HOME=/xxx/xxx/java
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib:$CLASSPATH
export JAVA_PATH=${JAVA_HOME}/bin:${JRE_HOME}/bin
export PATH=$PATH:${JAVA_PATH}
```

# 创建es 账号 设置数据目录权限



```bash
adduser elastic
chown -R   elastic:elastic /data*
chmod  -R  755 /data*
```

![img](https://upload-images.jianshu.io/upload_images/15537910-2af58200d0952500.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

1.png

# 修改系统参数



```bash
关闭centos7 防火墙
systemctl stop firewalld.service
关闭selinux 
SELINUX=disabled
cat/etc/sysctl.conf 增加两行
vm.max_map_count = 655360
vm.swappiness=1
sysctl -p 执行生效
修改20-nproc.conf文件
 cat /etc/security/limits.d/20-nproc.conf
soft nproc 2048
soft nproc 4096
修改最大打开文件个数
cat  /etc/security/limits.conf
root soft nofile 65535
root hard nofile 65535
* soft nofile 65535
* hard nofile 65535
elastic soft memlock unlimited
elastic hard memlock unlimited
```

# 安装es



```bash
修改配置文件/data/elasticsearch/config/elasticsearch.yml 增加如下配置
cluster.name: es-cluster  #集群名称
node.name: node-1
node.data: true
path.data: /data/es
path.logs: /data/es/logs
network.host: 10.0.46.75 #本机ip
http.port: 9200
transport.tcp.port: 9300
discovery.zen.ping.unicast.hosts: ["10.0.46.75:9300","10.0.45.211:9300", "10.0.44.6:9300"]  
discovery.zen.minimum_master_nodes: 2
bootstrap.memory_lock: true
thread_pool.index.queue_size: 5000 # Only suitable for ElasticSearch 6
thread_pool:
    write:
        queue_size: 5000  #硬盘写入需要根据硬盘性能来调
```

# 修改jvm



```bash
vim jvm.options  这个根据机器内存的50%修改
-Xms16g
-Xmx16g
```

# 启动es 需要进入普通账号启动



```bash
su elastic
cd /data/elasticsearch/bin/
./elasticsearch 看看是否报错如果不报错再后台启动，启动成功可以通过ip+端口访问返回数据说明成功。
```

# 安装kibana



```bash
修改配置文件
vim  /data/kibana/config/kibana.yml
server.host: "10.0.46.75"
elasticsearch.hosts: ["http://10.0.46.75:9200"]
启动 /data/kibana/bin/kibana 先执行启动能链接成功后再后台启动
```

![img](https://upload-images.jianshu.io/upload_images/15537910-8aa6ce5ff702f842.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

1.png

# skywalking 3台配置文件如下



```bash
vim application.yml
cluster:
  selector: ${SW_CLUSTER:zookeeper}
  standalone:
  # Please check your ZooKeeper is 3.5+, However, it is also compatible with ZooKeeper 3.4.x. Replace the ZooKeeper 3.5+
  # library the oap-libs folder with your ZooKeeper 3.4.x library.
  zookeeper:
    nameSpace: ${SW_NAMESPACE:""}
    hostPort: ${SW_CLUSTER_ZK_HOST_PORT:10.0.46.75:2181,10.0.45.211:2181,10.0.44.6:2181}
    sessionTimeout: 100000
enableDataKeeperExecutor: ${SW_CORE_ENABLE_DATA_KEEPER_EXECUTOR:true}
 dataKeeperExecutePeriod: ${SW_CORE_DATA_KEEPER_EXECUTE_PERIOD:5}

storage:
  selector: ${SW_STORAGE:elasticsearch}
  elasticsearch:
    nameSpace: ${SW_NAMESPACE:""}
    clusterNodes: ${SW_STORAGE_ES_CLUSTER_NODES:10.0.46.75:9200,10.0.45.211:9200,10.0.44.6:9200}
 superDatasetIndexShardsFactor: ${SW_STORAGE_ES_SUPER_DATASET_INDEX_SHARDS_FACTOR:6}
superDatasetIndexReplicasNumber: ${SW_STORAGE_ES_SUPER_DATASET_INDEX_REPLICAS_NUMBER:1}

agent-analyzer:
  selector: ${SW_AGENT_ANALYZER:default}
  default:
    sampleRate: ${SW_TRACE_SAMPLE_RATE:1000} # The sample rate precision is 1/10000. 10000 means 100% sample in default.
```

# 接钉钉报警配置



```bash
vim alarm-settings.yml 末尾追加
dingtalkHooks:
  textTemplate: |-
    {
      "msgtype": "text",
      "text": {
        "content": "Apache SkyWalking Alarm: \n %s."
      }
    }
  webhooks:
    - url: https://oapi.dingtalk.com/robot/send?access_token=1e1f91b0490a48aeb65bdaac5f5caxxx
      secret: SEC40546550f07c0e44ecec186d965b1b477176xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

# webapp.yml



```bash
server:
  port: 8081

collector:
  path: /graphql
  ribbon:
    ReadTimeout: 10000
    # Point to all backend's restHost:restPort, split by ,
    listOfServers: 10.0.46.75:12800,10.0.45.211:12800,10.0.44.6:12800    
```

# 启动/skywalking/bin/



```bash
./oapService.sh
./webappService.sh
分别启动看log 是否有报错
```

# zookeeper 3台机器配置文件如下:



```bash
进入conf配置文件
cp zoo_sample.cfg zoo.cfg
vim zoo.cfg 需要增加的如三台集群ip
dataDir=/data/zookeeper/data
dataLogDir=/data/zookeeper/logs
server.1=10.0.46.75:2888:3888
server.2=10.0.45.211:2888:3888
server.3=10.0.44.6:2888:3888
```

# 建立Zookeeper节点标识文件myid 需要3台机器分别执行:说明echo"1"是对应第一台机器



```bash
echo "1" >  /data/zookeeper/data/myid 
echo "2" >  /data/zookeeper/data/myid
echo "3" >  /data/zookeeper/data/myid
```

# 增加 zookeeper 环境变量



```bash
vim /etc/profile
export ZOOKEEPER_HOME=/data/zookeeper
export PATH=$ZOOKEEPER_HOME/bin:$PATH
source /etc/profile
```

# 启动Zookeeper



```bash
zkServer.sh start
zkServer.sh status
```

# 业务机器需要部署/skywalking/agent/ 修改的内如如下：



```bash
vim /agent/config/agent.config
agent.service_name=${SW_AGENT_NAME:zhd}   
agent.instance_name=${SW_AGEENT_INSTANCE_NAME:hostname:ip}
agent.span_limit_per_segment=${SW_AGENT_SPAN_LIMIT:2000}
collector.backend_service=${SW_AGENT_COLLECTOR_BACKEND_SERVICES:10.0.46.75:11800,10.0.45.211:11800,10.0.44.6:11800}
```



```bash
vim apm-trace-ignore-plugin.config  排除eureke
#  Multiple path comma separation, like trace.ignore_path=/eureka/**,/consul/**
trace.ignore_path=${SW_AGENT_TRACE_IGNORE_PATH:/eureka/**}
```

业务机器启动需要加参数 -javaagent:/data/agent/skywalking-agent.jar

# Grpc server thread pool is full, rejecting the task



```bash
这个错误是因为你的oap服务的吞吐量太弱，太弱这里可以理解为：你的存储性能跟不上，或者你的oap server的配置太低都有可能， 但agent上报又快，最有效的方法是增加oap服务数量，提高底层存储配置。如果没有条件看下面：

默认grpc server的线程池大小是4*cpu数，排队队列长度是10000，可以调整这两个参数大小：定位到application.yml文件。在core的default下增加

gRPCThreadPoolSize: 默认是4倍的cpu，这里可以调高,例如8核默认是4*8=32，可以调成40或更多

gRPCThreadPoolQueueSize：默认是10000，可以调高
```



