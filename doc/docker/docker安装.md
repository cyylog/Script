# Docker离线安装模式
注意：以下操作都需要用root账号

##### 1. 下载安装包

官方地址：https://download.docker.com/linux/static/stable/x86_64/

```
nohup wget https://download.docker.com/linux/static/stable/x86_64/docker-18.06.3-ce.tgz &
#后台下载
或者
wget http://10.7.102.125:8000/downloads/docker-18.06.3-ce.tgz
```
##### 2. 解压
```
tar -zxvf docker-18.06.3-ce.tgz
```
##### 3. 将解压出来的docker文件复制到 /usr/bin/ 目录下
```
cp docker/* /usr/bin/
```
##### 4. 在/etc/systemd/system/目录下新增docker.service文件，内容如下，这样可以将docker注册为service服务
```
vi /etc/systemd/system/docker.service
```
```
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd --selinux-enabled=false
ExecReload=/bin/kill -s HUP $MAINPID
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
# restart the docker process if it exits prematurely
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
```


给docker.service文件添加执行权限
```
chmod +x /etc/systemd/system/docker.service 
```
重新加载配置文件（每次有修改docker.service文件时都要重新加载下）
```
  systemctl daemon-reload 
```

##### 5. 启动docker

```
#启动
systemctl start docker

#设置开机启动
systemctl enable docker.service

#查看docker服务状态
systemctl status docker
```
上面显示Active: active (running)表示docker已安装成功

##### 6. 配置docker国内镜像地址
```
vi /etc/docker/daemon.json
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"],
  "insecure-registries": ["10.7.92.101:5000"]
}
systemctl restart docker
```
参考 https://www.cnblogs.com/kingsonfu/p/11576797.html

##### 7. 添加其他用户使用docker权限

~~~shell
# 添加www用户并修改密码
useradd www
passwd www #修改密码
echo 'www     ALL=(ALL)NOPASSWD:ALL' >> /etc/sudoers
sed -i 's/Defaults    requiretty/#Defaults    requiretty/g' /etc/sudoers
cat  /etc/sudoers

# 添加docker用户组
groupadd docker

# 把需要执行的docker用户添加进该组，这里是www用户
gpasswd -a www docker

# 重启 docker
systemctl restart docker

su www
# 运行成功
docker ps -a 

~~~

   

# [docker清理多余的镜像和stop的容器](https://www.cnblogs.com/kaishirenshi/p/12468009.html)

我们在使用 Docker 一段时间后，系统一般都会残存一些临时的、没有被使用的镜像文件，可以通过以下命令进行清理：

```
#按文件夹大小排序
du -sh * | sort -n
#清除docker冗余镜像
docker image prune -a
```

它支持的子命令有：

- `-a, --all`: 删除所有没有用的镜像，而不仅仅是临时文件；
- `-f, --force`：强制删除镜像文件，无需弹出提示确认；

另外，执行完 `docker image prune` 命令后，还是告诉我们释放了多少存储空间！



参考： https://blog.csdn.net/qq_40784783/article/details/112307745