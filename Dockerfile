#Creating an image with Centos 6 as base image
FROM centos:centos6

#Update the OS
RUN yum -y update

#Install epel-release package, wget, tar

RUN yum -y install epel-release && \
 yum -y install wget && \
 yum -y install tar

#Install MongoDB-server package
RUN yum -y install mongodb-server
RUN mkdir -p /data/db

#Porting MongoDB to 22222 port
EXPOSE 22222
ENTRYPOINT ["/usr/bin/mongod"]
 
#Installing Python
RUN cd /tmp && \
    wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz && \
    tar xvfz Python-2.7.8.tgz && \
    cd Python-2.7.8 && \
    ./configure --prefix=/usr/local && \
    make && \
    make altinstall
 
# Prepare environment
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin:$CATALINA_HOME/scripts
 
# Install Oracle Java8
RUN yum install -y java-1.8.0-openjdk.x86_64
 
RUN wget http://www-us.apache.org/dist/tomcat/tomcat-7/v7.0.76/bin/apache-tomcat-7.0.76.tar.gz && \
 tar -xvf apache-tomcat-7.0.76.tar.gz && \
 rm apache-tomcat*.tar.gz && \
 mv apache-tomcat* ${CATALINA_HOME}
 
RUN chmod +x ${CATALINA_HOME}/bin/*sh
 
# Create Tomcat admin user
#ADD create_admin_user.sh $CATALINA_HOME/scripts/create_admin_user.sh
#ADD tomcat.sh $CATALINA_HOME/scripts/tomcat.sh
#RUN chmod +x $CATALINA_HOME/scripts/*.sh
 
# Create tomcat user
RUN groupadd -r tomcat && \
 useradd -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin  -c "Tomcat user" tomcat && \
 chown -R tomcat:tomcat ${CATALINA_HOME}
 
WORKDIR /opt/tomcat
 
EXPOSE 8080
 
USER tomcat
CMD ["tomcat.sh", "-D", FOREGROUND]
