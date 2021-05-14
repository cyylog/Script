```shell
#!/bin/bash

mount /dev/sr0 /mnt &>/dev/null
#搭建本地仓库
cd /etc/yum.repos.d
cat >>yuzly.repo<<OK
[yuzly]
name=yuzly
baseurl=file:///mnt
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
OK
#清空yum缓存
echo "正在清除yum缓存...."
yum clean all &>/dev/null
yum makecache &>/dev/null
echo "yum缓存清除结束!"
```

