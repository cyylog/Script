# rabbitmq安装
注意事项:
> 1.安装rabbitmq前请先安装好docker，具体安装方法参考文档<<docker生产安装.md>>。
> 2.文档中IP地址为示意地址，安装时请替换为实际生产地址。
> 3.本文档不要一次性执行一个命令框（灰色框）内的全部命令，请按照步骤说明分步执行。
> 4.文档中主机名称mq-11，mq-12，mq-13也需要根据生产环境ip设置为对应的主机名称。


## 准备工作
*注意：以下操作都在3台机器上分别执行*

- 规划机器，操作系统必须为centos 7.5+。
  

~~~
192.168.2.11 mq-11
192.168.2.12 mq-12
192.168.2.13 mq-13
~~~

- 使用root账号安装docker，docker的安装方法参考文档<<docker生产安装.md>>

- 设置主机hostname
~~~
#机器192.168.2.11执行
hostnamectl --static set-hostname  mq-11

#机器192.168.2.12执行
hostnamectl --static set-hostname  mq-12

#机器192.168.2.13执行
hostnamectl --static set-hostname  mq-13
~~~

- 配置host文件

~~~
#3台机器配置hosts文件，加入内容
vi /etc/hosts
~~~
~~~
192.168.2.11 mq-11
192.168.2.12 mq-12
192.168.2.13 mq-13
~~~

- 准备文件夹


~~~shell
#准备文件夹
mkdir -p /app/rabbitmq/data
mkdir -p /app/rabbitmq/bin
~~~
## 创建启动脚本
~~~
#192.168.2.11创建启动脚本
vi /app/rabbitmq/bin/start.sh
~~~
~~~
docker run -d --net=host --name=rabbitmq \
        -e RABBITMQ_NODENAME=rabbitmq-11 \
        -e RABBITMQ_ERLANG_COOKIE='B7C6D8CA-4A03-49CB-8223-FD4EE7BE9150' \
        -v /app/rabbitmq/data:/var/lib/rabbitmq/mnesia \
        10.10.101.199:5000/rabbitmq:3.6.10-management-alpine
~~~

~~~
#192.168.2.12创建启动脚本
vi /app/rabbitmq/bin/start.sh
~~~
~~~
docker run -d --net=host --name=rabbitmq \
        -e RABBITMQ_NODENAME=rabbitmq-12 \
        -e RABBITMQ_ERLANG_COOKIE='B7C6D8CA-4A03-49CB-8223-FD4EE7BE9150' \
        -v /app/rabbitmq/data:/var/lib/rabbitmq/mnesia \
        10.10.101.199:5000/rabbitmq:3.6.10-management-alpine
~~~

~~~
#192.168.2.13创建启动脚本
vi /app/rabbitmq/bin/start.sh
~~~
~~~
docker run -d --net=host --name=rabbitmq \
        -e RABBITMQ_NODENAME=rabbitmq-13 \
        -e RABBITMQ_ERLANG_COOKIE='B7C6D8CA-4A03-49CB-8223-FD4EE7BE9150' \
        -v /app/rabbitmq/data:/var/lib/rabbitmq/mnesia \
        10.10.101.199:5000/rabbitmq:3.6.10-management-alpine
~~~

## 创建集群脚本

规划mq-11为主，mq-12，mq-13为从，在12，13机器上执行如下脚本

~~~
#192.168.2.12执行脚本
vi /app/rabbitmq/bin/initRabbitCluster.sh
~~~
~~~
docker exec rabbitmq rabbitmqctl stop_app
docker exec rabbitmq rabbitmqctl join_cluster rabbitmq-11@mq-11

docker exec rabbitmq rabbitmqctl start_app
docker exec rabbitmq rabbitmqctl set_policy HA '^(?!amq\.).*' '{"ha-mode": "all"}'
docker exec rabbitmq rabbitmqctl cluster_status
~~~


~~~
#192.168.2.13执行脚本
vi /app/rabbitmq/bin/initRabbitCluster.sh
~~~
~~~
docker exec rabbitmq rabbitmqctl stop_app
docker exec rabbitmq rabbitmqctl join_cluster rabbitmq-11@mq-11

docker exec rabbitmq rabbitmqctl start_app
docker exec rabbitmq rabbitmqctl set_policy HA '^(?!amq\.).*' '{"ha-mode": "all"}'
docker exec rabbitmq rabbitmqctl cluster_status
~~~

## 创建集群

- 3台机器上分别执行

~~~
sh /app/rabbitmq/bin/start.sh
~~~

- 从节点192.168.2.12，192.168.2.13上执行
~~~
sh /app/rabbitmq/bin/initRabbitCluster.sh
~~~

**验证**

使用新建的admin用户登录远程的机器 http://192.168.2.11:15672/

创建一个队列，例如以***"queue_"***开头，如果管理界面能看到队列Features状态显示为***“D HA”***说明镜像队列创建成功

安装完毕！