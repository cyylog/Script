# k8s监控prometheus安装

1.准备工作

~~~
下载kube-prometheus yaml文件
https://github.com/prometheus-operator/kube-prometheus/archive/v0.7.0.zip

解压
unzip v0.7.0.zip

~~~

2.安装

~~~
阅读readme文件
安装命令
kubectl create -f manifests/setup
待定前面的容器启动后执行
kubectl create -f manifests/


~~~

3.卸载

~~~

kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup

~~~

4.访问

~~~
端口转发grafana：
kubectl --address 0.0.0.0 --namespace monitoring port-forward svc/grafana 3000

浏览器访问
http://10.7.102.125:3000/
~~~

