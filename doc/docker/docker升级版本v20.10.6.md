# Docker离线升级版本v20.10.6
注意：以下操作都需要用root账号

##### 1. 下载安装包

官方地址：https://download.docker.com/linux/static/stable/x86_64/

```
nohup wget https://download.docker.com/linux/static/stable/x86_64/docker-20.10.6.tgz &
#后台下载
或者
wget http://10.7.102.125:8000/downloads/docker-20.10.6.tgz
```
##### 2. 解压并停止docker
```
#解压
tar -zxvf docker-20.10.6.tgz
#停止docker
sudo systemctl stop docker
```
##### 3. 将解压出来的docker文件复制到 /usr/bin/ 目录下
```
sudo cp docker/* /usr/bin/
```
##### 4. 重新启动docker

```
#启动
sudo systemctl start docker

#查看docker服务状态
sudo systemctl status docker
```
上面显示Active: active (running)表示docker已安装成功

