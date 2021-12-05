# 安装k8s集群-master卸载

#### 

```
#重置节点
kubeadm reset -f
yum remove -y kubelet kubeadm kubectl

#删除目录
rm -rf ~/.kube/
rm -rf /etc/cni/net.d
rm -rf /etc/kubernetes/
rm -rf /etc/cni
rm -rf /opt/cni
rm -rf /etc/systemd/system/kubelet.service.d
rm -rf /etc/systemd/system/kubelet.service
rm -rf /usr/bin/kube*
rm -rf /var/lib/etcd
rm -rf /var/etcd

#如果还要依赖没有卸载干净用rpm -e命令
rpm -e conntrack-tools-1.4.4-7.el7.x86_64
rpm -e cri-tools-1.13.0-0.x86_64
rpm -e libnetfilter_cthelper-1.0.0-11.el7.x86_64
rpm -e libnetfilter_cttimeout-1.0.0-7.el7.x86_64
rpm -e libnetfilter_queue-1.0.2-2.el7_2.x86_64
rpm -e socat-1.7.3.2-2.el7.x86_64


```

