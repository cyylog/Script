# 请官方文档为主

当前使用日期：2021.5.22

| 当前使用日期 |                           镜像版本                           |
| :----------: | :----------------------------------------------------------: |
|  2021.5.22   | k8s.gcr.io/sig-storage/nfs-subdir-external-provisioner:v4.0.2 |
|              |                                                              |



> 官方地址示例：https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner



PS: （这个笔记，不涉及nfs安装，请自行解决）

> 根据实际环境设定namespace

~~~shell

注：
-value: 192.168.0.129 、server: 192.168.0.129    #换成自己nfs的ip

- name:

NFS_PATH value: /xxx/xxxx   ##nfs共享的目录。

~~~



