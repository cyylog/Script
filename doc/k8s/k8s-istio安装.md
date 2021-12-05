# 安装istio

下载地址 https://github.com/istio/istio/releases/tag/1.7.6

``下面全部操作都在master上执行``

v1.8.3安装

```
#下载
wget https://github.com/istio/istio/releases/download/1.8.3/istio-1.8.3-linux-amd64.tar.gz

#解压缩
tar -zxvf istio-1.8.3-linux-amd64.tar.gz

#将istioctl移动到/usr/local/bin
mv istio-1.8.3/bin/istioctl /usr/local/bin/

#查看istioctl版本
istioctl version

#安装istio
istioctl install --set profile=demo -y
#default命名空间自动注入
kubectl label namespace default istio-injection=enabled
#查看pod情况：
kubectl get pods -n istio-system
```

v1.9.0安装

~~~
#下载
wget https://github.com/istio/istio/releases/download/1.9.0/istio-1.9.0-linux-amd64.tar.gz
#或者
wget http://10.7.102.125:8000/downloads/install-k8s/istio/istio-1.9.0-linux-amd64.tar.gz

#解压缩
tar -zxvf istio-1.9.0-linux-amd64.tar.gz

#将istioctl移动到/usr/local/bin
mv istio-1.9.0/bin/istioctl /usr/local/bin/

#查看istioctl版本
istioctl version

#安装istio前，提前准备好istio镜像并导入
istioctl install --set profile=demo -y 

#default命名空间自动注入
kubectl label namespace default istio-injection=enabled

#离线安装如果机器不能上网需要修改istio的configmap镜像拉取策略
kubectl get cm -n istio-system
[root@grpxxzxsapt007 istio-1.9.0]# kubectl get cm -n istio-system
NAME                     DATA   AGE
istio                    2      22m
istio-sidecar-injector   2      22m

#修改configmap中istio-sidecar-injector的镜像拉取imagePullPolicy的Always改为IfNotPresent
#或者可以尝试命令istioctl install --set profile=demo --set values.global.imagePullPolicy=IfNotPresent -y 
kubectl edit cm -n istio-system istio-sidecar-injector

:%s/imagePullPolicy `Always`/imagePullPolicy `IfNotPresent`/g

#如果安装失败，请检查各个node节点镜像是否导入成功，镜像在每个节点上都正常（理论上不需要更改镜像拉取策略就能顺利安装成功）
~~~



### 部署应用Bookinfo。

```
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
#如果安装失败使用下面命令重试,不能上网的电脑修改istio-sidecar-injector镜像拉取策略为IfNotPresent
kubectl replace --force -f samples/bookinfo/platform/kube/bookinfo.yaml

#验证Bookinfo应用运行正常。
#执行如下命令后应该会返回<title>Simple Bookstore App</title>。

kubectl exec -it $(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}') -c ratings -- curl productpage:9080/productpage | grep -o "<title>.*</title>"

#为应用定义ingress gateway:
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml

#确认gateway已经成功创建：
kubectl get gateway

#执行以下命令查看istio-ingressgateway服务的外部IP
kubectl get svc istio-ingressgateway -n istio-system 

NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)      


istio-ingressgateway   LoadBalancer   10.105.16.230   <pending>     15021:32665/TCP,80:31962/TCP,443:31827/TCP,31400:30210/TCP,15443:30519/TCP   34h
#访问masterIP+80端口对应暴露的31962
http://10.7.102.125:31962/productpage

```
### 部署kiali监控
```
#安装 Kiali and the other addons and wait for them to be deployed. 如果不成功多试几次
#如果机器不能上网，出现每次拉取镜像的情况修改samples/addons/kiali.yaml文件的拉取策略为IfNotPresent

kubectl apply -f samples/addons
kubectl rollout status deployment/kiali -n istio-system


#查看kaili
kubectl get pods -n istio-system|grep kiali
kiali-7476977cf9-bgl7d                  1/1     Running   0          55m

kubectl port-forward --address 0.0.0.0 {Kiali pod 名称} 20001 -n istio-system



```

参考官网安装成 https://istio.io/latest/docs/setup/getting-started/#download

----------------------------------------------------------------------

#### kubectl命令总结

~~~
#重新创建
kubectl replace --force -f ./deploy.yaml

#创建namespace
kubectl create namespace my-namespace

#修改pod配置
kubectl edit pod details-v1-c44b64d7-55lgm

#实时查看pod状态
watch kubectl get pod

~~~



## istio的卸载

~~~
#删除addons
kubectl delete -f samples/addons
istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -

#删除命名空间
kubectl delete namespace istio-system

#删除注入标记
kubectl label namespace default istio-injection-


~~~

## bookinfo卸载

~~~
samples/bookinfo/platform/kube/cleanup.sh

kubectl get virtualservices   #-- there should be no virtual services
kubectl get destinationrules  #-- there should be no destination rules
kubectl get gateway           #-- there should be no gateway
kubectl get pods              #-- the Bookinfo pods should be deleted

~~~

