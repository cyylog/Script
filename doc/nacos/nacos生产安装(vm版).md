
# nacos集群安装

注意事项:
> 1.安装rabbitmq前请先安装好docker，具体安装方法参考文档<<docker生产安装.md>>。
> 2.文档中IP地址为示意地址，安装时请替换为实际生产地址。
> 3.本文档不要一次性执行一个命令框（灰色框）内的全部命令，请按照步骤说明分步执行。
> 4.<<***>>标记的内容代表变量，部署时应将替换为实际内容。例如<<IP地址>>替换为192.168.1.11

## 准备工作
规划机器，nacos版本1.3.2

~~~
192.168.1.11 nacos-11
192.168.1.12 nacos-12
192.168.1.13 nacos-13
~~~
为每台机器创建nacos账号，并设置密码

~~~shell
groupadd nacos
useradd -g nacos nacos
passwd nacos #修改密码，此处输入生产新密码 nacos@123
echo 'nacos     ALL=(ALL)NOPASSWD:ALL' >> /etc/sudoers
sed -i 's/Defaults    requiretty/#Defaults    requiretty/g' /etc/sudoers
cat  /etc/sudoers
~~~
设置主机hostname

~~~
#机器192.168.2.11执行
hostnamectl --static set-hostname  nacos-11

#机器192.168.2.12执行
hostnamectl --static set-hostname  nacos-12

#机器192.168.2.13执行
hostnamectl --static set-hostname  nacos-13
~~~


## 安装步骤
### 1.下载安装包
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

~~~
### 2.导入mysql配置

- 新建nacos库（字符编码设置为utf8mb4）

- 进入/app/nacos/nacos/conf文件夹，导入nacos-mysql.sql文件

### 3.修改配置

*注意：以下操作在3台机器上都要执行，下面是一台机器操作步骤*


~~~shell
cd /app/nacos/nacos/conf/
vi application.properties
~~~
~~~
#设置端口
server.port=8848
#设置本机ip地址
nacos.inetutils.ip-address=<<本机IP，例如：192.168.1.11>>

### 配置MySQL datasource，创建nacos库，提前导入conf/nacos-mysql.sql
spring.datasource.platform=mysql
db.num=1
db.url.0=jdbc:mysql://<<IP地址>>:<<端口，例如3306>>/nacos?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=UTC
db.user=<<***>>
db.password=<<***>>
~~~
- 配置集群
~~~shell
cp cluster.conf.example cluster.conf
vi cluster.conf
~~~
~~~
#设置集群
192.168.1.11:8848
192.168.1.12:8848
192.168.1.13:8848
~~~


### 4.集群启动与停止
*三台机器都需要操作*

~~~shell

#nacos赋予权限
chown -R nacos:nacos /app/nacos
su nacos
#启动
cd /app/nacos/nacos
/app/nacos/nacos/bin/startup.sh -m cluster

/app/nacos/nacos/bin/startup.sh -m standalone

#停止
/app/nacos/nacos/bin/shutdown.sh
~~~

### 5.访问管理页面
> http://192.168.1.11:8848/nacos/ 
>
> 用户和密码 nacos/nacos
>
> 查看leader http://192.168.1.11:8848/nacos/v1/ns/raft/leader

安装完毕！

