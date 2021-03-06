# Using a compact OS
FROM ubuntu:13.10 

MAINTAINER changedi <jysoftware@gmail.com> 

# update source  
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe"> /etc/apt/sources.list  
RUN apt-get update  
  
# Install curl  
RUN apt-get -y install curl  
  
# Install JDK 7  
RUN cd /tmp &&  curl -L 'http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz' -H 'Cookie: oraclelicense=accept-securebackup-cookie; gpw_e24=Dockerfile' | tar -xz  
RUN mkdir -p /usr/lib/jvm  
RUN mv /tmp/jdk1.7.0_65/ /usr/lib/jvm/java-7-oracle/  
  
# Set Oracle JDK 7 as default Java  
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-7-oracle/bin/java 300     
RUN update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-7-oracle/bin/javac 300  
  
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle/  
  
# Install tomcat7  
RUN cd /tmp && curl -L 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.8/bin/apache-tomcat-7.0.8.tar.gz' | tar -xz  
RUN mv /tmp/apache-tomcat-7.0.8/ /opt/tomcat7/  
  
ENV CATALINA_HOME /opt/tomcat7  
ENV PATH $PATH:$CATALINA_HOME/bin:$JAVA_HOME/bin  

# ADD ace-java-demo-1.0.0.war /tmp/myapp/
# RUN cd /tmp/myapp && jar -xvf ace-java-demo-1.0.0.war
# RUN rm -rf ace-java-demo-1.0.0.war
# RUN cp -R /tmp/myapp /opt/tomcat7/webapps/myapp
# RUN mkdir /opt/tomcat7/webapps/myapp
RUN rm -rf /opt/tomcat7/webapps/ROOT/*
ADD ace-java-demo-1.0.0.war /opt/tomcat7/webapps/ROOT/ace-java-demo-1.0.0.war
RUN cd /opt/tomcat7/webapps/ROOT/ && jar -xvf ace-java-demo-1.0.0.war
 
ADD tomcat-users.xml /opt/tomcat7/conf/tomcat-users.xml
# ADD server.xml /opt/tomcat7/conf/server.xml
RUN cat /opt/tomcat7/conf/serv*.xml
RUN ls /opt/tomcat7/conf
RUN ls /opt/tomcat7/webapps

ADD tomcat7.sh /etc/init.d/tomcat7  
RUN chmod 755 /etc/init.d/tomcat7  
  
# install nginx
RUN apt-get install nginx -y
ADD ./nginx/nginx-conf /etc/nginx/conf.d

# Expose ports
EXPOSE 80


# Define default command.  
ENTRYPOINT service tomcat7 start && tail -f /opt/tomcat7/logs/catalina.out

