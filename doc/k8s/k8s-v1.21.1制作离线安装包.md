# 安装k8s集群v1.21.1

## 系统初始化

~~~
#### 关闭防火墙
systemctl stop firewalld.service
systemctl status firewalld.service
systemctl disable firewalld

#### 关闭Swap
swapoff -a
sed -ri 's/.*swap.*/#&/' /etc/fstab
echo "vm.swappiness = 0" >> /etc/sysctl.conf 
sysctl -p

#### 关闭selinux
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config

#### 设置启动参数
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system
~~~

## 准备docker

下载docker相关二进制安装包

~~~
官方地址：https://download.docker.com/linux/static/stable/x86_64/
~~~

## 准备kubelet

下载kubelet相关二进制安装包

~~~
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=0
EOF

#下载kubelet-1.21.1 kubeadm-1.21.1 kubectl-1.21.1离线安装包
yum install --downloadonly --downloaddir=/root/kube-1.21.1  kubelet-1.21.1 kubeadm-1.21.1 kubectl-1.21.1

#离线安装命令
rpm -ivh /root/k8s/*.rpm

systemctl enable kubelet && systemctl start kubelet

#到github下载kube二进制文件
https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.21.md
~~~

## 准备镜像

~~~bash

# 初始化master，添加--image-repository参数，默认镜像下载会失败
kubeadm init \
  --apiserver-advertise-address=192.168.68.131 \
  --image-repository registry.aliyuncs.com/google_containers \
  --kubernetes-version v1.21.1 \
  --service-cidr=10.96.0.0/12 \
  --pod-network-cidr=10.244.0.0/16 \
  --ignore-preflight-errors=all

#如果init成功执行如下命令
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 安装网络
kubectl apply -f yaml/calico.yaml
sleep 120s

#>>>>>>>>>>>>>>>>>>>>>>>>一直等待镜像下载完毕。。。
#查看集群
kubectl get pods -n kube-system

#安装dashboard
kubectl create -f yaml/k8sdashbordui.yaml
sleep 120s

kubectl get pods -n kubernetes-dashboard

#命令获取token
kubectl -n kube-system describe $(kubectl -n kube-system get secret -n kube-system -o name | grep namespace) | grep token
~~~

一直等待镜像下载完毕。。。

> 注意：

~~~bash
#calico官方yaml文件下载地址：
https://docs.projectcalico.org/manifests/calico.yaml

#解决coredns无法下载的问题
docker pull registry.aliyuncs.com/google_containers/coredns/coredns:v1.8.0 //阿里私服里没有此镜像

#从coredns官网先下载然后加tag
docker tag coredns/coredns:1.8.0 registry.aliyuncs.com/google_containers/coredns/coredns:v1.8.0
docker save registry.aliyuncs.com/google_containers/coredns/coredns:v1.8.0 -o coredns_v1.8.0.tar

~~~



~~~bash
#导出镜像脚本

docker save calico/node:v3.19.0 -o calico_node_v3.19.0.tar
docker save calico/pod2daemon-flexvol:v3.19.0 -o calico_pod2daemon-flexvol_v3.19.0.tar
docker save calico/cni:v3.19.0  -o calico_cni_v3.19.0.tar
docker save calico/kube-controllers:v3.19.0 -o calico_kube-controllers_v3.19.0.tar
docker save registry.aliyuncs.com/google_containers/kube-apiserver:v1.21.1  -o kube-apiserver_v1.21.1.tar
docker save registry.aliyuncs.com/google_containers/kube-proxy:v1.21.1  -o kube-proxy_v1.21.1.tar
docker save registry.aliyuncs.com/google_containers/kube-controller-manager:v1.21.1 -o kube-controller-manager_v1.21.1.tar
docker save registry.aliyuncs.com/google_containers/kube-scheduler:v1.21.1  -o kube-scheduler_v1.21.1.tar
docker save kubernetesui/dashboard:v2.2.0 -o dashboard_v2.2.0.tar
docker save registry.aliyuncs.com/google_containers/pause:3.4.1 -o pause_3.4.1.tar
docker save registry.aliyuncs.com/google_containers/coredns/coredns:v1.8.0  -o coredns_v1.8.0.tar
docker save kubernetesui/metrics-scraper:v1.0.6 -o metrics-scraper_v1.0.6.tar
docker save registry.aliyuncs.com/google_containers/etcd:3.4.13-0 -o etcd_3.4.13-0.tar


~~~



~~~bash
#导入镜像脚本
docker load < server/bin/kube-apiserver.tar
docker load < server/bin/kube-controller-manager.tar
docker load < server/bin/kube-proxy.tar
docker load < server/bin/kube-scheduler.tar

docker tag k8s.gcr.io/kube-apiserver-amd64:v1.21.1 registry.aliyuncs.com/google_containers/kube-apiserver:v1.21.1  
docker tag k8s.gcr.io/kube-proxy-amd64:v1.21.1 registry.aliyuncs.com/google_containers/kube-proxy:v1.21.1  
docker tag k8s.gcr.io/kube-controller-manager-amd64:v1.21.1 registry.aliyuncs.com/google_containers/kube-controller-manager:v1.21.1  
docker tag k8s.gcr.io/kube-scheduler-amd64:v1.21.1 registry.aliyuncs.com/google_containers/kube-scheduler:v1.21.1  

docker load < ./images/calico_node_v3.19.0.tar
docker load < ./images/calico_pod2daemon-flexvol_v3.19.0.tar
docker load < ./images/calico_cni_v3.19.0.tar
docker load < ./images/calico_kube-controllers_v3.19.0.tar
docker load < ./images/kube-apiserver_v1.21.1.tar
docker load < ./images/kube-proxy_v1.21.1.tar
docker load < ./images/kube-controller-manager_v1.21.1.tar
docker load < ./images/kube-scheduler_v1.21.1.tar
docker load < ./images/dashboard_v2.2.0.tar
docker load < ./images/pause_3.4.1.tar
docker load < ./images/coredns_v1.8.0.tar
docker load < ./images/metrics-scraper_v1.0.6.tar
docker load < ./images/etcd_3.4.13-0.tar

~~~

# 制作离线安装脚本

## 初始化server脚本

`vi step1-initServer.sh`(所有节点都安装)

~~~bash
#!/bin/bash

#### 关闭防火墙
systemctl stop firewalld.service
systemctl status firewalld.service
systemctl disable firewalld

#### 关闭Swap
swapoff -a
sed -ri 's/.*swap.*/#&/' /etc/fstab
echo "vm.swappiness = 0" >> /etc/sysctl.conf 
sysctl -p

#### 关闭selinux
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config

#### 设置启动参数
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

#### 安装docker
#离线安装命令
tar -zxvf ./docker0/docker-20.10.6.tgz
cp docker/* /usr/bin/
rm -rf docker

#设置docker
cat <<EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "registry-mirrors": ["http://hub-mirror.c.163.com"],
  "insecure-registries": ["10.7.92.101:5000"]
}
EOF

ls /etc/docker/daemon.json

cat <<EOF >  /etc/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd --selinux-enabled=false
ExecReload=/bin/kill -s HUP $MAINPID
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
# restart the docker process if it exits prematurely
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF

#加执行权限
chmod +x /etc/systemd/system/docker.service
systemctl daemon-reload

#设置开机启动
systemctl enable docker.service

#启动
systemctl start docker


#查看docker服务状态
systemctl status docker

#导入镜像脚本
docker load < ./images/calico_node_v3.19.0.tar
docker load < ./images/calico_pod2daemon-flexvol_v3.19.0.tar
docker load < ./images/calico_cni_v3.19.0.tar
docker load < ./images/calico_kube-controllers_v3.19.0.tar
docker load < ./images/kube-apiserver_v1.21.1.tar
docker load < ./images/kube-proxy_v1.21.1.tar
docker load < ./images/kube-controller-manager_v1.21.1.tar
docker load < ./images/kube-scheduler_v1.21.1.tar
docker load < ./images/dashboard_v2.2.0.tar
docker load < ./images/pause_3.4.1.tar
docker load < ./images/coredns_v1.8.0.tar
docker load < ./images/metrics-scraper_v1.0.6.tar
docker load < ./images/etcd_3.4.13-0.tar

#离线安装kubelet,kubeadm,kubectl
rpm -ivh ./kube-1.21.1/*.rpm

systemctl enable kubelet && systemctl start kubelet

~~~

## 初始化master脚本

 `vi initMaster.sh`(master节点安装)

~~~
#!/bin/bash

echo 'please input master ip(ex:192.168.68.131) :'
read masterIp

# 初始化master，添加--image-repository参数，默认镜像下载会失败
kubeadm init \
  --apiserver-advertise-address=192.168.68.131 \
  --image-repository registry.aliyuncs.com/google_containers \
  --kubernetes-version v1.21.0 \
  --service-cidr=10.96.0.0/12 \
  --pod-network-cidr=10.244.0.0/16 \
  --ignore-preflight-errors=all

#如果init成功执行如下命令
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 安装网络
kubectl apply -f yaml/calico.yaml
sleep 120s

#查看集群
kubectl get pods -n kube-system

#安装dashboard
kubectl create -f yaml/k8sdashbordui.yaml
sleep 60s

kubectl get pods -n kubernetes-dashboard

#命令获取token
kubectl -n kube-system describe $(kubectl -n kube-system get secret -n kube-system -o name | grep namespace) | grep token
~~~

## 卸载脚本

`vi uninstall.sh`

~~~
#!/bin/bash

#重置节点
kubeadm reset

#删除目录
rm -rf $HOME/.kube
rm -rf /etc/cni/net.d
rm -rf /etc/kubernetes/

~~~

