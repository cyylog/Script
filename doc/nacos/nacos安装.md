# nacos安装

# docker启动单机nacos

> 下载镜像

~~~shell
docker pull nacos/nacos-server:1.3.2
~~~

> 创建启动脚本

~~~shell
#vi run.sh
docker rm -f nacos
docker run --restart=always --env MODE=standalone --name=nacos -d -v /app/nacos/data:/home/nacos/data -p 8848:8848 nacos/nacos-server:1.3.2
~~~



# nacos集群安装

## 准备工作：

- 规划机器 
~~~
node1 192.168.1.11
node2 192.168.1.12
node3 192.168.1.13
~~~
- 创建nacos账号，并设置密码
~~~shell
groupadd nacos
useradd -g nacos nacos
passwd nacos #修改密码
echo 'nacos     ALL=(ALL)NOPASSWD:ALL' >> /etc/sudoers
sed -i 's/Defaults    requiretty/#Defaults    requiretty/g' /etc/sudoers
cat  /etc/sudoers
~~~

## 安装步骤
> 1.下载安装包
~~~shell
#nacos下载地址
https://github.com/alibaba/nacos/tags
#后台下载
nohup wget https://github.com/alibaba/nacos/releases/download/1.3.2/nacos-server-1.3.2.tar.gz &
#或者内网下载
wget http://10.7.102.125:8000/downloads/nacos-server-1.3.2.tar.gz
#解压
mkdir -p /app/nacos/
tar -zxvf nacos-server-1.3.2.tar.gz -C /app/nacos/
#nacos赋予权限
chown -R nacos:nacos /app/nacos
~~~


> 2.修改配置

- **配置mysql，新建nacos库，导入nacos解压后文件conf/nacos-mysql.sql**

~~~shell
cd /app/nacos/nacos/conf/
vi application.properties

#设置端口
server.port=8848
#node1 node2 node3三台机器ip设置
nacos.inetutils.ip-address=192.168.1.11 

### 配置MySQL datasource，创建nacos库，提前导入conf/nacos-mysql.sql
spring.datasource.platform=mysql
db.num=1
db.url.0=jdbc:mysql://<<mysql ip address>>:3306/nacos?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=UTC
db.user=<<***>>
db.password=<<***>>
~~~
- 配置集群
~~~shell
cp cluster.conf.example cluster.conf
vi cluster.conf

#设置集群
192.168.1.11:8848
192.168.1.12:8848
192.168.1.13:8848
~~~

- 拷贝nacos目录到node2，node3并更改相应ip和端口


> 3.集群启动与停止
~~~shell
cd /app/nacos/nacos
./bin/startup.sh -m cluster

#停止
./bin/shutdown.sh
~~~

> 4.访问管理页面
> http://192.168.1.11:8848/nacos/ 
>
> 用户和密码 nacos/nacos
>
> 查看leader http://192.168.1.11:8848/nacos/v1/ns/raft/leader
