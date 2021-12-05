# k8s集群-证书更新


## 准备工作

查看证书是否有效：

```bash
[root@node1 ~]# sudo openssl x509 -in /etc/kubernetes/pki/apiserver.crt -noout -text |grep ' Not '
输出：
            Not Before: Apr 23 01:28:23 2021 GMT
            Not After : Apr 23 01:28:24 2022 GMT
```

在master上使用如下命令查看证书过期时间

~~~bash
[root@node1 ~]# kubeadm alpha certs check-expiration
[check-expiration] Reading configuration from the cluster...
[check-expiration] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'

CERTIFICATE                EXPIRES                  RESIDUAL TIME   CERTIFICATE AUTHORITY   EXTERNALLY MANAGED
admin.conf                 Apr 23, 2022 01:28 UTC   354d                                    no      
apiserver                  Apr 23, 2022 01:28 UTC   354d            ca                      no      
apiserver-etcd-client      Apr 23, 2022 01:28 UTC   354d            etcd-ca                 no      
apiserver-kubelet-client   Apr 23, 2022 01:28 UTC   354d            ca                      no      
controller-manager.conf    Apr 23, 2022 01:29 UTC   354d                                    no      
etcd-healthcheck-client    Apr 23, 2022 01:28 UTC   354d            etcd-ca                 no      
etcd-peer                  Apr 23, 2022 01:28 UTC   354d            etcd-ca                 no      
etcd-server                Apr 23, 2022 01:28 UTC   354d            etcd-ca                 no      
front-proxy-client         Apr 23, 2022 01:28 UTC   354d            front-proxy-ca          no      
scheduler.conf             Apr 23, 2022 01:29 UTC   354d                                    no      

CERTIFICATE AUTHORITY   EXPIRES                  RESIDUAL TIME   EXTERNALLY MANAGED
ca                      Apr 21, 2031 01:28 UTC   9y              no      
etcd-ca                 Apr 21, 2031 01:28 UTC   9y              no      
front-proxy-ca          Apr 21, 2031 01:28 UTC   9y              no 

~~~

## 更新证书操作

- 备份原有的证书文件

```
cp -r /etc/kubernetes/pki/ /etc/kubernetes/pki_backup
```

- 开始更新证书

```bash
[root@node1 ~]# kubeadm alpha certs renew all
输出：
W0503 16:56:56.303876   51598 configset.go:348] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
certificate embedded in the kubeconfig file for the admin to use and for kubeadm itself renewed
certificate for serving the Kubernetes API renewed
certificate the apiserver uses to access etcd renewed
certificate for the API server to connect to kubelet renewed
certificate embedded in the kubeconfig file for the controller manager to use renewed
certificate for liveness probes to healthcheck etcd renewed
certificate for etcd nodes to communicate with each other renewed
certificate for serving etcd renewed
certificate for the front proxy client renewed
certificate embedded in the kubeconfig file for the scheduler manager to use renewed

```

覆盖.kube/config文件

```bash
mv $HOME/.kube/config $HOME/.kube/config.old
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
```

注意注意注意：

~~~bash
#注意此处有大坑，kubelet.conf需要重新生成，否则重启kubelet会有问题
mv /etc/kubernetes/kubelet.conf /etc/kubernetes/kubelet.conf.old

kubeadm init phase kubeconfig kubelet
systemctl restart kubelet
systemctl status kubelet

~~~

- 完成后重启master上kube-apiserver,kube-controller,kube-scheduler,etcd这4个容器

```bash
docker restart `docker ps | grep etcd | awk '{print $1}'`

docker restart `docker ps | grep kube-apiserver | awk '{print $1}'`

docker restart `docker ps | grep kube-controller | awk '{print $1}'`

docker restart `docker ps | grep kube-scheduler | awk '{print $1}'`

```

或者

~~~bash
docker ps -a | grep -v pause | grep -E "etcd|scheduler|controller|apiserver" | awk '{print $1}' | awk '{print "docker","restart",$1}' | bash
~~~



查看pod集群状态，检查刚刚重启的status是否为Running(一般会等待2分钟左右)

```
kubectl get pods --all-namespaces -o wide
```

查看证书过期时间

~~~bash
[root@node1 ~]# kubeadm alpha certs check-expiration
[check-expiration] Reading configuration from the cluster...
[check-expiration] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'

CERTIFICATE                EXPIRES                  RESIDUAL TIME   CERTIFICATE AUTHORITY   EXTERNALLY MANAGED
admin.conf                 May 03, 2022 08:56 UTC   364d                                    no      
apiserver                  May 03, 2022 08:56 UTC   364d            ca                      no      
apiserver-etcd-client      May 03, 2022 08:57 UTC   364d            etcd-ca                 no      
apiserver-kubelet-client   May 03, 2022 08:57 UTC   364d            ca                      no      
controller-manager.conf    May 03, 2022 08:57 UTC   364d                                    no      
etcd-healthcheck-client    May 03, 2022 08:57 UTC   364d            etcd-ca                 no      
etcd-peer                  May 03, 2022 08:57 UTC   364d            etcd-ca                 no      
etcd-server                May 03, 2022 08:57 UTC   364d            etcd-ca                 no      
front-proxy-client         May 03, 2022 08:57 UTC   364d            front-proxy-ca          no      
scheduler.conf             May 03, 2022 08:57 UTC   364d                                    no      

CERTIFICATE AUTHORITY   EXPIRES                  RESIDUAL TIME   EXTERNALLY MANAGED
ca                      Apr 21, 2031 01:28 UTC   9y              no      
etcd-ca                 Apr 21, 2031 01:28 UTC   9y              no      
front-proxy-ca          Apr 21, 2031 01:28 UTC   9y              no      

~~~

更新完毕！（v1.19.7亲测可用，v1.21.0版本中kubeadm alpha certs改为kubeadm certs）

问题查找：

~~~
journalctl -f -u kubelet

tailf /var/log/messages

kubectl describe nodes <<nodeName>>
~~~

