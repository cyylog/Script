#### 下载docker离线安装包

~~~
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#下载docker-ce-18.06.3.ce-3.el7离线安装包
yum install --downloadonly --downloaddir=/root/docker docker-ce-18.06.3.ce-3.el7

#离线安装命令
rpm -ivh /root/docker/*.rpm
~~~



#### 下载kubeadm,kubelet,kubectl离线安装包

```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

#下载kubelet-1.19.7 kubeadm-1.19.7 kubectl-1.19.7离线安装包
yum install --downloadonly --downloaddir=/root/k8s  kubelet-1.19.7 kubeadm-1.19.7 kubectl-1.19.7

#离线安装命令
rpm -ivh /root/tars/k8s/*.rpm

```



