# Zycus_assignment
A Dockerfile to install python2.7,MongoDB and Apache Tomcat7

To create a build image execute the below cmmand
docker build -t="App" .

To run the Dockerfile such that once the container boots, apache tomcat's home page is accessible from the host 7080
docker run -v -p 7080:8080 -i -t App
