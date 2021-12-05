## 安装准备工作

~~~bash
#提前下载镜像

#gogs镜像
docker pull gogs/gogs
# Drone的Server
docker pull drone/drone:1
# Drone的Runner
docker pull drone/drone-runner-docker:1
~~~

## gogs安装

~~~shell

docker run -d \
  -p 10022:22 -p 10080:3000  \
  -e TZ="Asia/Shanghai" \
  -v /export/gogs:/data  \
  --restart=always \
  --name=gogs \
  gogs/gogs

~~~

访问gogs地址：http://10.7.102.127:10080/ （自己注册jack用户即管理员）

注意：gogs在安装的过程中设置http端口为3000，不要变更为映射宿主机端口，否则会导致容器重启无法访问

## drone安装

安装`drone-server`

~~~bash
docker run -d \
  -v /export/drone/data:/data \
  -e DRONE_AGENTS_ENABLED=true \
  -e DRONE_GOGS_SERVER=http://10.7.102.127:10080 \
  -e DRONE_RPC_SECRET=mydrone666 \
  -e DRONE_SERVER_HOST=10.7.102.127:3080 \
  -e DRONE_SERVER_PROTO=http \
  -e DRONE_USER_CREATE=username:jack,admin:true \
  -e TZ="Asia/Shanghai" \
  -p 3080:80 \
  --restart=always \
  --name=drone \
  drone/drone:1
~~~

安装`drone-runner-docker`

~~~bash
docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e DRONE_RPC_PROTO=http \
  -e DRONE_RPC_HOST=10.7.102.127:3080 \
  -e DRONE_RPC_SECRET=mydrone666 \
  -e DRONE_RUNNER_CAPACITY=2 \
  -e DRONE_RUNNER_NAME=runner-docker \
  -e TZ="Asia/Shanghai" \
  -p 3000:3000 \
  --restart=always \
  --name=runner-docker \
  drone/drone-runner-docker:1
~~~

访问gogs地址：http://10.7.102.127:3080/ 