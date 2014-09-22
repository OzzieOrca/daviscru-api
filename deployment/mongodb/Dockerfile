FROM ubuntu
MAINTAINER Scotty Waggoner <ozzieorca@gmail.com>

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
RUN apt-get update -y
RUN apt-get install -y mongodb-org

CMD /usr/bin/mongod -f /data/mongodb.conf

EXPOSE 27017
EXPOSE 28017

#cd ~/docker-builder/mongodb && docker build -t quay.io/ozzieorca/mongodb . && docker push quay.io/ozzieorca/mongodb