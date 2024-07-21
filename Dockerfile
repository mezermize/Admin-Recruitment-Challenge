# Use centos:7 as the base image
FROM centos:7

# Replace CentOS repository configuration
COPY CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

# Install necessary packages, including `which` for debugging
RUN yum install -y java-1.8.0-openjdk wget which

# Set environment variables
ENV JAVA_HOME=/usr
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$JAVA_HOME/bin:$CATALINA_HOME/bin:$PATH

# Verify Java installation
RUN java -version
RUN which java

# Download and extract Tomcat 8.5
RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.82/bin/apache-tomcat-8.5.82.tar.gz -O /tmp/tomcat.tar.gz \
    && mkdir -p $CATALINA_HOME \
    && tar xzf /tmp/tomcat.tar.gz --strip-components=1 -C $CATALINA_HOME \
    && rm /tmp/tomcat.tar.gz

# Verify that catalina.sh exists
RUN ls -la $CATALINA_HOME/bin/catalina.sh

# Copy SSL certificates and keystore
COPY ssl/keystore.jks $CATALINA_HOME/conf/

# Update Tomcat configuration for SSL
#RUN sed -i 's/port="8443"/port="4041"/' $CATALINA_HOME/conf/server.xml \
   # && sed -i 's/keystoreFile=".*"/keystoreFile="\/usr\/local\/tomcat\/conf\/keystore.jks"/' $CATALINA_HOME/conf/server.xml \
  #  && sed -i 's/keystorePass=".*"/keystorePass="changeit"/' $CATALINA_HOME/conf/server.xml \
 #   && sed -i 's/clientAuth="false"/clientAuth="false"/' $CATALINA_HOME/conf/server.xml \
#    && sed -i 's/sslProtocol="TLS"/sslProtocol="TLS"/' $CATALINA_HOME/conf/server.xml
    
    
# Update Tomcat configuration for SSL
RUN sed -i '/<\/Service>/i \
  <Connector port="4041" protocol="org.apache.coyote.http11.Http11NioProtocol" \
             maxThreads="150" SSLEnabled="true" scheme="https" secure="true" \
             clientAuth="false" sslProtocol="TLS" \
             keystoreFile="${catalina.base}/conf/keystore.jks" \
             keystorePass="changeit" />' $CATALINA_HOME/conf/server.xml
    
    
    
    

# Download sample web app and deploy
RUN wget https://tomcat.apache.org/tomcat-8.5-doc/appdev/sample/sample.war -O $CATALINA_HOME/webapps/sample.war

# Expose port 4041
EXPOSE 4041

# Start Tomcat
CMD ["catalina.sh", "run"]

