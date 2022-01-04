## 安装步骤

### 部署 NFS SC

~~~shell
kubectl create namespace loki
kubectl apply -f nfs-sc/ 
~~~



### 部署 kube-prometheus

~~~shell
kubectl create namespace monitoring

kubectl apply -f setup/  -n monitoring
kubectl apply -f adapter/	-n monitoring
kubectl apply -f node-exporter/  -n monitoring
kubectl apply -f alertmanager/	-n monitoring
kubectl apply -f prometheus/	-n monitoring
kubectl apply -f serviceMonitor/	-n monitoring
kubectl apply -f blackbox/ 		-n monitoring
kubectl apply -f kube-state-metrics/	-n monitoring
kubectl apply -f grafana/  	-n monitoring
kubectl apply -f . -n	monitoring               
~~~



### 修改grafana端口

~~~shell
kubectl edit svc -n monitoring grafana

···

  ports:
  - name: http
    nodePort: 30030
    port: 3000
    protocol: TCP
    targetPort: 3000

···

  type: NodePort


···
~~~

