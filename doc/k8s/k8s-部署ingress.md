# ingress部署

1. 部署ingress-nginx

```
#下载ingress-nginx的yaml文件
wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/mandatory.yaml

#删除目录
kubectl create -f mandatory.yaml


```



```yaml
#注意：mandatory.yaml中Deployment 设置hostNetwork为true
...
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-ingress-controller
  namespace: ingress-nginx
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: ingress-nginx
      app.kubernetes.io/part-of: ingress-nginx
  template:
    metadata:
      labels:
        app.kubernetes.io/name: ingress-nginx
        app.kubernetes.io/part-of: ingress-nginx
      annotations:
        prometheus.io/port: "10254"
        prometheus.io/scrape: "true"
    spec:
      # hostNetwork设置为true
      hostNetwork: true
      # wait up to five minutes for the drain of connections
      terminationGracePeriodSeconds: 300

...
```



部署nginx

~~~
#创建web
 kubectl create deploy web --image=nginx:1.18-alpine
#暴露端口
 kubectl expose deployment web --port=80 --target-port=80 --type=ClusterIP
#查看状态
 kubectl get pod |grep web
 kubectl get svc |grep web
~~~



```
apiVersion: v1
kind: Service
metadata:
  labels:
    app: web
  name: web
  namespace: default
spec:
  ports:
  - nodePort: 31532
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: web
  type: ClusterIP
```



创建ingress规则

vi ingress-web.yaml

~~~

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: demo-ingress
spec:
  rules:
    - host: demo.example.com
      http:
        paths:
          - backend:
              serviceName: web
              servicePort: 80

~~~

