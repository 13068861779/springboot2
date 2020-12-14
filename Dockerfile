

# First stage: complete build environment
FROM maven:3.5.0-jdk-8-alpine AS builder
# 进入容器的app目录, 然后拷贝当前目录(根目录)的所有文件到容器的当前目录中(/app)
COPY . .
RUN mvn clean package


From openjdk:8-jre-alpine
#将本地文件挂载到当前容器
#VOLUME   /tmp
#复制jar文件和配置文件所在的目录到容器里
#ADD  /target/my-app.jar  /app.jar
#ADD  /conf       /conf

COPY --from=builder /target/my-app.jar app.jar
COPY /conf /conf

#声明需要暴露的端口
EXPOSE  8006
#配置容器启动后执行的命令,并指定使用项目外部的配置文件
ENTRYPOINT  ["java","-Xms256m","-Xmx256m","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar","--spring.config.location=/conf/application.yml"]

