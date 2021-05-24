OpenSSH的8.5p1及之前的scp允许在scp.c远程功能中注入命令，攻击者可利用该漏洞执行任意命令。目前绝大多数linux系统受影响，因此我们要升级OpenSSH 来解决。

```
ssh -V 查看当前版本
下载最新版本 Zlib 升级
 wget -c http://www.zlib.net/zlib-1.2.11.tar.gz
tar zxf zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure --prefix=/usr/local/zlib
make
make install



升级 OpenSSL
https://www.openssl.org/source/old/
https://www.openssl.org/source/old/1.1.1/openssl-1.1.1.tar.gz
tar zxf openssl-1.1.1.tar.gz
 cd openssl-1.1.1
./config   --prefix=/usr/local/openssl
make
make test 
make install
错误：begin failed--compilation aborted at .././test/run_tests.pl
解决：sudo yum install  perl  perl-devel
错误：Parse errors: No plan found in TAP output
解决：忽略错误，继续执行安装



升级 OpenSSL
yum -y install pam-devel
wget -c https://openbsd.hk/pub/OpenBSD/OpenSSH/portable/openssh-8.6p1.tar.gz
tar zxf openssh-8.6p1.tar.gz
cd contrib/redhat
cp -rf  sshd.init /etc/init.d/sshd
cp  -rf  sshd.pam /etc/pam.d/sshd
cd openssh-8.6p1
 ./configure  --prefix=/usr --sysconfdir=/etc/ssh --with-pam --with-zlib=/usr/local/zlib --with-ssl-dir=/etc/ssh --with-md5-passwords
make
make install
/etc/init./sshd  restart
ssh -V
```





作者：HaoDongZ
链接：https://www.jianshu.com/p/b558f07d6e73
