# 安装k8s集群-准备工作

注意事项:

> 1.安装k8s前请先安装好docker，具体安装方法参考文档<<docker生产安装.md>>。
> 2.文档中IP地址为示意地址，安装时请替换为实际生产地址。
> 3.本文档不要一次性执行一个命令框（灰色框）内的全部命令，应按照步骤说明分步执行。


## 准备工作

规划机器。操作系统：CentOS Linux release 7.9.2009 (Core)

~~~
192.168.1.11 master
192.168.1.12 node1
192.168.1.13 node2
~~~

拷贝文件

~~~
#拷贝文件都3台机器
scp -r tars root@192.168.1.11:/root/
scp -r tars root@192.168.1.12:/root/
scp -r tars root@192.168.1.13:/root/
~~~

设置hostname

~~~bash
#机器192.168.2.11执行
hostnamectl --static set-hostname  master

#机器192.168.2.12执行
hostnamectl --static set-hostname  node1

#机器192.168.2.13执行
hostnamectl --static set-hostname  node2

~~~
```
#所有机器上执行，hosts文件追加本地解析记录
cat <<EOF >>  /etc/hosts
192.168.1.11    master
192.168.1.12    node1
192.168.1.13    node2
EOF

cat /etc/hosts
```
## 安装步骤

*以下命令在所有机器执行*

~~~shell
vi step1-initServer.sh
~~~

~~~
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

#离线安装参考《docker生产安装》
tar -zxvf tars/docker-18.06.3-ce.tgz 
cp docker/* /usr/bin/

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
#启动
systemctl start docker

#设置开机启动
systemctl enable docker.service

#查看docker服务状态
systemctl status docker

#设置docker
cat <<EOF > /etc/docker/daemon.json
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"],
  "insecure-registries": ["10.7.92.101:5000"]
}
EOF

#重启
systemctl restart docker

#导入镜像脚本
docker load < ./tars/1.tar
docker load < ./tars/2.tar
docker load < ./tars/3.tar
docker load < ./tars/4.tar
docker load < ./tars/5.tar
docker load < ./tars/6.tar
docker load < ./tars/7.tar
docker load < ./tars/9.tar
docker load < ./tars/10.tar
docker load < ./tars/11.tar
docker load < ./tars/12.tar
docker load < ./tars/13.tar
docker load < ./tars/14.tar


#离线安装kubelet-1.19.7,kubeadm-1.19.7,kubectl-1.19.7
rpm -ivh ./tars/k8s/*.rpm

systemctl enable kubelet && systemctl start kubelet
~~~

*以下命令在master机器执行*

~~~
vi initMaster.sh
~~~

~~~
#!/bin/bash

echo 'please input master ip(ex:192.168.68.131) :'
read masterIp

# 初始化master，添加--image-repository参数，默认镜像下载会失败
kubeadm init \
  --apiserver-advertise-address=$masterIp \
  --image-repository registry.aliyuncs.com/google_containers \
  --kubernetes-version v1.19.7 \
  --service-cidr=10.96.0.0/12 \
  --pod-network-cidr=10.244.0.0/16 \
  --ignore-preflight-errors=all

#如果init成功执行如下命令
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 安装网络
kubectl apply -f tars/calico.yaml
sleep 120s

#查看集群
kubectl get pods -n kube-system

#安装dashboard
kubectl create -f tars/recommended.yaml
sleep 120s

kubectl get pods -n kubernetes-dashboard

#命令获取token
kubectl -n kube-system describe $(kubectl -n kube-system get secret -n kube-system -o name | grep namespace) | grep token
~~~

## 命令总结

~~~
#查看k8s所需镜像
kubeadm config images list

#删除node1节点：
kubectl delete node node1

#重新生成token：
kubeadm token create

#获取token
kubeadm token list

#获取ca证书sha256编码hash值
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'

#替换加入集群命令
kubeadm join 10.7.128.82:6443 --token <<9jtavl.4e3bkhyplhykxljt>> \
    --discovery-token-ca-cert-hash sha256:<<f710731e05e86ceeab0908a8d549b3c93a5355f5bab05f40e70cf16f94409fdd>> 

~~~

