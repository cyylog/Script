# zabbix批量修改主机名



## 一.说明

通过zabbix开放的api进行批量操作，默认主机名是IP地址，尤其是自动发现的时候批量添加，如果挨个手动改会很累，这里配置批量加入。

![file](https://linkdevops.oss-cn-beijing.aliyuncs.com/wp-content/uploads/2020/10/image-1602920423949.png)

新建文件ips.txt

```shell
主机名 IP
主机名 IP
主机名 IP
```

## 二.批量更新主机名

```python
#!/usr/bin/python3
# _*_ coding:utf-8 _*_
import json
import requests
 
#zabbix服务器的IP地址
zabbix_ip = "127.0.0.1"
#zabbix的用户名
zabbix_user = "Admin"
#zabbix的密码
zabbix_pass = "123456"
#zabbix api接口地址
url = "http://" + zabbix_ip + ":8000/api_jsonrpc.php"
#zabbix api定义的访问头部信息
post_header = {'Content-Type': 'application/json'}
 
 
 
# 调用zabbix api需要身份令牌auth
def get_auth():
    post_data = {
        "jsonrpc": "2.0",
        "method": "user.login",
        "params": {
            "user": zabbix_user,
            "password": zabbix_pass
        },
        "id": "1"
    }
 
    ret = requests.post(url, data=json.dumps(post_data), headers=post_header)
    zabbix_ret = json.loads(ret.text)
    print(zabbix_ret)
    if 'result' not in zabbix_ret:
        print('login error')
    else:
        auth = zabbix_ret.get('result')
        return auth
 
 
# 以IP信息获取主机id
def get_hostid():
    hostid_get = {
        "jsonrpc": "2.0",
        "method": "host.get",
        "params": {
            "output": "extend",
            "filter": {
                "host": [
                    host_ip
                ]
            }
        },
        "auth": Token,
        "id": 2,
    }
 
    res2 = requests.post(url, data=json.dumps(hostid_get), headers=post_header)
    res3 = res2.json()
    #print(res3)
    res4 = res3['result']
    try:
        host_id = res4[0]['hostid']
        return host_id
    except:
        print("zabbix中不存在，跳过")
        return "不行"
 
# 以主机ID来修改主机名
def update_hostname():
    hostname_update = {
        "jsonrpc": "2.0",
        "method": "host.update",
        "params": {
            "hostid": host_id,
            "name": host_name
        },
        "auth": Token,
        "id": 3
    }
 
    res10 = requests.post(url, data=json.dumps(hostname_update), headers=post_header)
    res11 = res10.json()
    #print(res11)
 
if __name__ == '__main__':
    '''
    ips.txt里的文件内容：
    主机名1 ip1
    主机名2 ip2
    主机名3 ip3
    '''
    with open("ips.txt", "r", encoding="utf8") as f:
        for line in f:
            line = line.split(" ")
            host_name = line[0]
            host_ip = line[1].strip()
            #print(host_name)
            #print(host_ip)
 
            Token = get_auth()
            #print(Token)
            host_id = get_hostid()
            if host_id == "不行":
                continue
            #print(host_id)
            update_hostname()
            print(host_name,host_ip,"已添加完成")
```

------

https://52wiki.cn/project-47/doc-798/)