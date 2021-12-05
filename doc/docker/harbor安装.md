# 安装harbor

# 安装docker-compose

官方地址： https://github.com/docker/compose/releases 

~~~
nohup wget https://github.com/docker/compose/releases/download/1.28.2/docker-compose-Linux-x86_64 &
或者
wget http://10.7.102.125:8000/downloads/docker-compose-Linux-x86_64
~~~

将下载下来的“docker-compose-Linux-x86_64”文件移动到 /usr/local/bin，并改名为“docker-compose”。

```
sudo mv docker-compose-Linux-x86_64 /usr/local/bin/docker-compose
```

接着执行如下命令添加可执行权限：

```
sudo chmod +x /usr/local/bin/docker-compose
```

最后使用 docker-compose -v 命令测试是否安装成功

# Harbor离线安装

##### 1. 下载安装包

官方地址：https://github.com/goharbor/harbor/releases/tag/v2.1.3

```
#后台下载
nohup wget https://github.com/goharbor/harbor/releases/download/v2.1.3/harbor-offline-installer-v2.1.3.tgz &
或者
wget http://10.7.102.125:8000/downloads/harbor-offline-installer-v2.1.3.tgz
```
##### 2. 解压
```
tar -zxvf harbor-offline-installer-v2.1.3.tgz -C /export/
```
##### 3. 调整配置
从harbor.yml.tmpl复制一个harbor.yml，然后修改前面几行，自定义Hostname,port,禁用https，设置管理员密码。
~~~
cd /export/harbor
cp harbor.yml.tmpl harbor.yml
~~~
~~~
###vi harbor.yml
hostname: 10.7.92.101
http:
  port: 8009

#https:
#  port: 443
#  certificate: /your/certificate/path
#  private_key: /your/private/key/path

harbor_admin_password: Harbor12345
~~~
##### 4. 安装并启动

```
./install.sh
```

##### 5. 登陆

~~~
http://10.7.92.101:8009/harbor/ 
admin/Harbor12345
~~~

注：Harbor的默认镜像存储路径在/data/registry目录下，映射到docker容器里面的/storage目录下。



## harbor磁盘清理

按下面步骤执行成功

~~~
1.停止docker harbor
cd /export/harbor/harbor/
/usr/local/bin/docker-compose stop

2.预览运行效果
docker run -it --name gc --rm --volumes-from registry vmware/registry:2.6.2-photon garbage-collect --dry-run /etc/registry/config.yml

3.执行删除
docker run -it --name gc --rm --volumes-from registry vmware/registry:2.6.2-photon garbage-collect  /etc/registry/config.yml

4.重启harbor
/usr/local/bin/docker-compose start
~~~

