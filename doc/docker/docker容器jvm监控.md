# docker容器jvm监控

- Dockerfile加入java启动参数

~~~
# java opt 参数
-Djava.rmi.server.hostname=10.7.92.101 
-Dcom.sun.management.jmxremote 
-Dcom.sun.management.jmxremote.rmi.port=1099 
-Dcom.sun.management.jmxremote.port=1099 
-Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false
~~~

~~~
#示例
FROM 10.7.92.101:5000/tomcat:8.5.41-alpine
MAINTAINER Jack.he
RUN echo 'Asia/Shanghai' >/etc/timezone &&  mkdir /app
WORKDIR /app/
COPY *.jar /app/
ENV JAVA_OPTS="$JAVA_OPTS -Xms2048m -Xmx2048m "
ENV JAVA_OPTS="$JAVA_OPTS -Djava.rmi.server.hostname=10.7.92.101 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.rmi.port=1099 -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar dj-message-log.jar" ]
~~~

- 启动visualvm

![image-20210115101827009](/Users/jack/Library/Application Support/typora-user-images/image-20210115101827009.png)

