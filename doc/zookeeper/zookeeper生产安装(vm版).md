# zookeeper集群安装

注意事项:
> 1.安装zookeeper前请先安装好docker，具体安装方法参考文档<<docker生产安装.md>>。
> 2.文档中IP地址为示意地址，安装时请替换为实际生产地址。
> 3.本文档不要一次性执行一个命令框（灰色框）内的全部命令，应按照步骤说明分步执行。


## 准备工作

规划机器
~~~
node1 192.168.1.11
node2 192.168.1.12
node3 192.168.1.13
~~~

设置主机hostname

~~~bash
#机器192.168.2.11执行
hostnamectl --static set-hostname  zk-11

#机器192.168.2.12执行
hostnamectl --static set-hostname  zk-12

#机器192.168.2.13执行
hostnamectl --static set-hostname  zk-13
~~~
为每台机器创建zookeeper账号，并设置密码
~~~bash
groupadd zookeeper
useradd -g zookeeper zookeeper
passwd zookeeper #修改密码为zookeeper@1234，生产环境修改为其他密码
~~~
## 安装步骤
*注意：以下操作在3台机器上都要执行*

### 1. 下载稳定版本

官方地址：https://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.5.8/

```bash
wget https://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.5.8/apache-zookeeper-3.5.8-bin.tar.gz
#或者
wget http://10.7.102.125:8000/downloads/apache-zookeeper-3.5.8-bin.tar.gz
```
### 2. 解压
```
mkdir -p /app/zookeeper/data/
tar -zxvf apache-zookeeper-3.5.8-bin.tar.gz -C /app/zookeeper/
```
### 3. 修改配置
```
cd /app/zookeeper/apache-zookeeper-3.5.8-bin
cp conf/zoo_sample.cfg conf/zoo.cfg
```

- 修改以下配置
```
vim conf/zoo.cfg
```
```
# 配置数据保存目录
dataDir=/app/zookeeper/data
# 只保留3个快照文件（用于自动清除历史数据）
autopurge.snapRetainCount=3
# 每隔1小时扫描一次数据目录
autopurge.purgeInterval=1
# 注意，此处生产修改成实际的ip地址
server.1=10.7.128.82:2888:3888
server.2=10.7.128.83:2888:3888
server.3=10.7.128.84:2888:3888
```
- 配置myid

~~~
echo '1' > /app/zookeeper/data/myid #node1机器执行
echo '2' > /app/zookeeper/data/myid #node2机器执行
echo '3' > /app/zookeeper/data/myid #node3机器执行
~~~

~~~
#文件夹权限赋予zookeeper用户
chown -R zookeeper:zookeeper /app/zookeeper/
~~~

### 4. 启动服务

启动zookeeper集群，启动顺序随意没要求。

~~~
#切换到zookeeper用户启动
su zookeeper
cd /app/zookeeper/apache-zookeeper-3.5.8-bin
bin/zkServer.sh start

#停止命令
bin/zkServer.sh stop
~~~

查看zookeeper的状态。

```
#查看状态
bin/zkServer.sh status
#登陆
bin/zkCli.sh
[zk: localhost:2181(CONNECTED) 3] ls /
[zookeeper]
[zk: localhost:2181(CONNECTED) 4] ls /zookeeper
[config, quota]
```

安装完毕！

