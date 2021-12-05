### 1准备3台虚拟机

规划机器。操作系统：CentOS Linux release 7.9.2009 (Core)

~~~
192.168.68.164 master01
192.168.68.165 master02
192.168.68.167 master03
~~~

拷贝文件

~~~
#拷贝文件都3台机器
scp -r install-k8s/ root@192.168.68.164:/root/
scp -r install-k8s/ root@192.168.68.165:/root/
scp -r install-k8s/ root@192.168.68.167:/root/
~~~

设置hostname

~~~bash
#机器192.168.68.164执行
hostnamectl --static set-hostname  master01

#机器192.168.68.165执行
hostnamectl --static set-hostname  master02

#机器192.168.68.167执行
hostnamectl --static set-hostname  master03
~~~

### 2虚拟机设置

~~~
#执行初始化脚本
sh step1-initServer.sh
~~~

### 3安装docker并安装haproxy和keepalive


#### 创建 HAProxy 启动脚本

> 该步骤在 `master01 master02 master03` 执行

```bash
mkdir -p /usr/local/kubernetes/lb
vi /usr/local/kubernetes/lb/start-haproxy.sh

# 输入内容如下
#!/bin/bash
# 修改为你自己的 Master 地址
MasterIP1=192.168.68.164
MasterIP2=192.168.68.165
MasterIP3=192.168.68.167
# 这是 kube-apiserver 默认端口，不用修改
MasterPort=6443

# 容器将 HAProxy 的 6444 端口暴露出去
docker run -d --restart=always --name HAProxy-K8S -p 6444:6444 \
        -e MasterIP1=$MasterIP1 \
        -e MasterIP2=$MasterIP2 \
        -e MasterIP3=$MasterIP3 \
        -e MasterPort=$MasterPort \
        wise2c/haproxy-k8s

# 设置权限
chmod +x start-haproxy.sh
```


#### 创建 Keepalived 启动脚本

> 该步骤在 `master01 master02 master03` 执行

```bash
mkdir -p /usr/local/kubernetes/lb
vi /usr/local/kubernetes/lb/start-keepalived.sh

# 输入内容如下
#!/bin/bash
# 修改为你自己的虚拟 IP 地址
VIRTUAL_IP=192.168.68.200
# 虚拟网卡设备名
INTERFACE=ens33
# 虚拟网卡的子网掩码
NETMASK_BIT=24
# HAProxy 暴露端口，内部指向 kube-apiserver 的 6443 端口
CHECK_PORT=6444
# 路由标识符
RID=10
# 虚拟路由标识符
VRID=160
# IPV4 多播地址，默认 224.0.0.18
MCAST_GROUP=224.0.0.18

docker run -itd --restart=always --name=Keepalived-K8S \
        --net=host --cap-add=NET_ADMIN \
        -e VIRTUAL_IP=$VIRTUAL_IP \
        -e INTERFACE=$INTERFACE \
        -e CHECK_PORT=$CHECK_PORT \
        -e RID=$RID \
        -e VRID=$VRID \
        -e NETMASK_BIT=$NETMASK_BIT \
        -e MCAST_GROUP=$MCAST_GROUP \
        wise2c/keepalived-k8s

# 设置权限
chmod +x start-keepalived.sh
```


### 4安装kubeadm kubelet kubectl 

### 5初始化 master01 并安装calico网络

### 6其它两台 master加入到集群

### 7安装 dashboard 


