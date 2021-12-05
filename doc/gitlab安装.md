# Gitlab安装

# docker安装gitlab

先下载gitlab镜像

```
docker pull gitlab/gitlab-ce

mkdir -p /app/gitlab/config
mkdir -p /app/gitlab/logs 
mkdir -p /app/gitlab/data
```

编写运行脚本vi run.sh
```
docker run --detach \
  --hostname 10.7.128.85 \
  --publish 443:443 --publish 80:80 \
  --name gitlab \
  --restart always \
  --volume /app/gitlab/config:/etc/gitlab \
  --volume /app/gitlab/logs:/var/log/gitlab \
  --volume /app/gitlab/data:/var/opt/gitlab \
  --privileged=true \
  gitlab/gitlab-ce:latest

```

访问地址： http://10.7.128.85

