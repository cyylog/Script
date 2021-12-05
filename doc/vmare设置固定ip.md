# vmare设置固定ip

- 修改网络设置必须是root用户或是sudo vi /etc/sysconfig/network-scripts/ifcfg-ens33 

~~~bash
sudo vi /etc/sysconfig/network-scripts/ifcfg-ens33 
 
#修改内容如下：
BOOTPROTO="static"

IPADDR="192.168.68.131"
NETMASK="255.255.255.0"
GATEWAY="192.168.68.2"
DNS1="114.114.114.114"
~~~

- 需要重新启动网络配置，如下图输入：service network restart

~~~bash
service network restart
~~~

注意：如果重启还不能上网，设置下本机dns服务器地址114.114.114.114或者8.8.8.8

参考：https://www.jianshu.com/p/b42ed273ef6f

