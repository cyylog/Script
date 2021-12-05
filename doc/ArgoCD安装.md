# ArgoCD安装-准备工作

## 安装步骤

下载yaml文件

~~~shell
#官方地址 https://github.com/argoproj/argo-cd
https://github.com/argoproj/argo-cd/releases/tag/v2.0.1

https://gitee.com/mirrors/ArgoProject/tree/v2.0.1/

#下载yaml文件 https://github.com/argoproj/argo-cd/blob/v2.0.1/manifests/install.yaml

~~~

导入镜像

~~~
#每个node节点都执行如下操作
cd /root/install-k8s/argo/images
sh load.sh

~~~

执行yaml文件


~~~

kubectl create namespace argocd

#注意官方下载的yaml文件image拉取策略为always，如果是离线安装请修改成IfNotPresent
#修改443端口暴露为type: NodePort
kubectl apply -n argocd -f install.yaml

~~~

启动argocd

~~~
[root@zk-1 argo]# kubectl get svc -n argocd
NAME                    TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
argocd-dex-server       ClusterIP   10.109.150.192   <none>        5556/TCP,5557/TCP,5558/TCP   24s
argocd-metrics          ClusterIP   10.107.84.62     <none>        8082/TCP                     24s
argocd-redis            ClusterIP   10.97.140.219    <none>        6379/TCP                     24s
argocd-repo-server      ClusterIP   10.111.90.171    <none>        8081/TCP,8084/TCP            24s
argocd-server           NodePort    10.110.42.70     <none>        80:32557/TCP,443:30605/TCP   24s
argocd-server-metrics   ClusterIP   10.107.231.151   <none>        8083/TCP                     24s
[root@zk-1 argo]# 

#查看admin登陆密码
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

~~~

新建app>执行cd操作

