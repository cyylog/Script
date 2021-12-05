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

### 3安装haproxy和keepalive

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

### 4初始化 Master

> 该步骤在 `master01` 执行

- 创建工作目录并导出配置文件

```bash
# 导出配置文件到工作目录
kubeadm config print init-defaults --kubeconfig ClusterConfiguration > kubeadm.yml
```

`vi kubeadm.yml`

~~~yaml
apiVersion: kubeadm.k8s.io/v1beta2
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  # 修改为主节点 IP
  advertiseAddress: 192.168.68.164
  bindPort: 6443
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  name: kubernetes-master
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta2
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
# 配置 Keepalived 地址和 HAProxy 端口
controlPlaneEndpoint: "192.168.68.200:6444"
controllerManager: {}
dns:
  type: CoreDNS
etcd:
  local:
    dataDir: /var/lib/etcd
# 国内不能访问 Google，修改为阿里云
imageRepository: registry.aliyuncs.com/google_containers
kind: ClusterConfiguration
# 修改版本号
kubernetesVersion: v1.19.7
networking:
  dnsDomain: cluster.local
  # 配置成 Calico 的默认网段
  podSubnet: "10.244.0.0/16"
  serviceSubnet: 10.96.0.0/12
scheduler: {}

~~~



~~~
# kubeadm 初始化
kubeadm init --config=kubeadm.yml | tee kubeadm-init.log

# 配置 kubectl
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# 安装网络
kubectl apply -f tars/calico.yaml
sleep 120s

#查看集群
kubectl get pods -n kube-system
~~~

### 5节点加入

> 该步骤在 ` master02 master03` 执行

~~~
#master02 master03创建文件夹
mkdir -p /etc/kubernetes/pki/etcd/

#拷贝master01上的证书到机器master02
scp /etc/kubernetes/pki/ca.* root@192.168.68.165:/etc/kubernetes/pki
scp /etc/kubernetes/pki/sa.* root@192.168.68.165:/etc/kubernetes/pki
scp /etc/kubernetes/pki/front-proxy-ca.* root@192.168.68.165:/etc/kubernetes/pki/
scp /etc/kubernetes/pki/etcd/ca.* root@192.168.68.165:/etc/kubernetes/pki/etcd/
scp /etc/kubernetes/admin.conf root@192.168.68.165:/etc/kubernetes/


#拷贝master01上的证书到机器master03
scp /etc/kubernetes/pki/ca.* root@192.168.68.167:/etc/kubernetes/pki
scp /etc/kubernetes/pki/sa.* root@192.168.68.167:/etc/kubernetes/pki
scp /etc/kubernetes/pki/front-proxy-ca.* root@192.168.68.167:/etc/kubernetes/pki/
scp /etc/kubernetes/pki/etcd/ca.* root@192.168.68.167:/etc/kubernetes/pki/etcd/
scp /etc/kubernetes/admin.conf root@192.168.68.167:/etc/kubernetes/

#在文件kubeadm-init.log找到如下命令，将master02 master03加入
#其他master加入执行如下命令
kubeadm join 192.168.68.200:6444 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:9ee9c17195287307cdf8bf8658b597d71fc788d69fe34df885fbd41986db6a5a \
    --control-plane 
#加入成功后master02 master03执行如下命令
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#node加入执行
kubeadm join 192.168.68.200:6444 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:9ee9c17195287307cdf8bf8658b597d71fc788d69fe34df885fbd41986db6a5a

~~~

### 6安装dashboard

> 该步骤在 `master01  执行

~~~
#安装dashboard
kubectl create -f tars/recommended.yaml

kubectl get pods -n kubernetes-dashboard

#命令获取token
kubectl -n kube-system describe $(kubectl -n kube-system get secret -n kube-system -o name | grep namespace) | grep token
~~~



参考；https://www.funtl.com/zh/service-mesh-kubernetes/%E9%AB%98%E5%8F%AF%E7%94%A8%E9%9B%86%E7%BE%A4.html#%E5%AE%89%E8%A3%85-haproxy-keepalived