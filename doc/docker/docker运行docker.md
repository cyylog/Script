# Docker离线升级版本v20.10.6


~~~
FROM centos:7.9.2009
MAINTAINER Jack.he
WORKDIR /app
RUN yum install docker -y
COPY  daemon.json /etc/docker/daemon.json
CMD ["/bin/bash"]
~~~



~~~
docker build -f Dockerfile -t 10.7.92.101:5000/app/centos:v1.0  .
  
docker run -v /var/run/docker.sock:/var/run/docker.sock -it  10.7.92.101:5000/app/centos:v1.0 bash
 
docker pull boxboat/kubectl:1.21.0
docker pull bitnami/kubectl:1.21.0

docker run -it -v  /root/.kube/config:/root/.kube/config bitnami/kubectl:1.21.0 version

docker run --rm --name kubectl -v /etc/kubernetes/admin.conf:/etc/kubernetes/admin.conf -v /root/.kube/config:/.kube/config bitnami/kubectl:latest


 kubectl get secret deployment-controller-token-84jsb -n kube-system -o jsonpath='{.data.ca\.crt}' && echo

kubectl get secret deployment-controller-token-84jsb -n kube-system -o jsonpath='{.data.token}' | base64 --decode && echo


~~~



#maven镜像使用

~~~

docker run -it --rm --name my-maven-project \
  -v /Users/jack/.m2:/root/.m2  \
  -v /Users/jack/tmp/dj-admin:/usr/src/mymaven \
  -w /usr/src/mymaven 10.7.92.101:5000/app/maven:3.8.1-jdk-8 mvn clean package -Dmaven.test.skip=true


~~~





~~~


docker run -it --rm --name my-node \
  -v /export/cicd/dj-admin-dev/src/dj-admin-html:/usr/src \
  -v /export/drone/.npm:/root/.npm \
  -v /export/drone/.node_modules:/usr/src/node_modules \
  -w /usr/src 10.7.92.101:5000/app/node:14-alpine sh -c 'pwd && npm config set registry http://dtc.djbx.com/nexus/repository/npm-group && npm install @vue/cli -g && npm cache clean --force && npm install && ls -a && npm run build && ls -a'



~~~

