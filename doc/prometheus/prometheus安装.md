
# 准备工作：

规划机器，操作系统版本centos7.5+
~~~
node1 192.168.1.11
node2 192.168.1.12
node3 192.168.1.13
~~~
创建redis账号，并设置密码
~~~
groupadd prometheus
useradd -g prometheus prometheus
passwd prometheus #修改密码 prometheus@1234
echo 'prometheus     ALL=(ALL)NOPASSWD:ALL' >> /etc/sudoers
sed -i 's/Defaults    requiretty/#Defaults    requiretty/g' /etc/sudoers
cat  /etc/sudoers
~~~
规划目录

~~~
sudo mkdir -p /export/prometheus
sudo chown -R prometheus:prometheus /export/prometheus/
~~~

# prometheus安装

- **虚拟机安装prometheus**

下载地址：https://prometheus.io/download/#prometheus

```bash
#下载prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.24.0/prometheus-2.24.0.linux-amd64.tar.gz 
#解压
tar -zxvf prometheus-2.24.0.linux-amd64.tar.gz -C /export/prometheus/

#创建启动脚本vi start.sh
/export/prometheus/prometheus/prometheus  --config.file="/export/prometheus/prometheus/prometheus.yml"

#启动
sh start.sh
```

- **docker安装prometheus**

~~~
#下载镜像
docker pull prom/prometheus:v2.22.2
~~~

**启动命令**

```bash
docker run \
  --name prometheus \
  -d -p 9090:9090 \
  -v /export/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus:v2.22.2 \
  --web.read-timeout=5m \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/prometheus \
  --web.max-connections=512 \
  --storage.tsdb.retention=30d \
  --query.timeout=2m
```

访问prometheus地址：

~~~
http://服务器ip:9090
~~~



# node_exporter安装

- **虚拟机安装**

下载地址：https://prometheus.io/download/#node_exporter

```bash
#下载node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
#解压
mkdir -p /export/node_exporter/
tar -zxvf node_exporter-1.0.1.linux-amd64.tar.gz -C /export/node_exporter/

#启动
/export/node_exporter/node_exporter-1.0.1.linux-amd64/node_exporter
```

- **使用 docker安装**

```bash
#下载镜像
docker pull prom/node-exporter:v1.0.1

#启动
docker run -d -p 9100:9100 \
  --name node_exporter \
  -v "/proc:/host/proc:ro" \
  -v "/sys:/host/sys:ro" \
  -v "/:/rootfs:ro" \
  --net="host" \
  prom/node-exporter
```

访问如下地址：

~~~
http://服务器ip:9100
~~~

配置Prometheus监控node

~~~
#vim /export/prometheus/prometheus/prometheus.yml

#最后一行添加，监控171，172，173三台机器,
  - job_name: 'es-171'
    static_configs:
    - targets: ['10.7.103.171:9100']

  - job_name: 'es-172'
    static_configs:
    - targets: ['10.7.103.172:9100']

  - job_name: 'es-173'
    static_configs:
    - targets: ['10.7.103.173:9100']

#重启prometheus
/export/prometheus/prometheus/prometheus  --config.file="/export/prometheus/prometheus/prometheus.yml"
~~~



# grafana安装

- **虚拟机安装方式**

下载地址：https://grafana.com/grafana/download

~~~
#下载grafana
wget https://dl.grafana.com/oss/release/grafana-7.3.6-1.x86_64.rpm
sudo yum install grafana-7.3.6-1.x86_64.rpm

#启动
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
~~~

- **docker方式安装**

~~~
#下载镜像
docker pull grafana/grafana

#暴露端口启动
docker run -d -p 3000:3000 --name=grafana grafana/grafana

~~~

  

访问：http://10.7.92.103:3000/login admin/admin 第一次登陆修改密码为123456

![image-20210109153206992](/Users/jack/Library/Application Support/typora-user-images/image-20210109153206992.png)

添加数据源

![image-20210109153309529](/Users/jack/Library/Application Support/typora-user-images/image-20210109153309529.png)

![image-20210109153356381](/Users/jack/Library/Application Support/typora-user-images/image-20210109153356381.png)

![image-20210109153614866](/Users/jack/Library/Application Support/typora-user-images/image-20210109153614866.png)

导入模板

![image-20210111103334419](/Users/jack/Library/Application Support/typora-user-images/image-20210111103334419.png)

![image-20210111103358076](/Users/jack/Library/Application Support/typora-user-images/image-20210111103358076.png)

![image-20210111103447477](/Users/jack/Library/Application Support/typora-user-images/image-20210111103447477.png)













