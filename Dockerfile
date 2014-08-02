FROM ubuntu
MAINTAINER Scotty Waggoner <ozzieorca@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y curl wget vim
RUN apt-get install -y software-properties-common python-software-properties

RUN apt-get install -y nginx
RUN apt-add-repository ppa:hachre/dart
RUN apt-get update
RUN apt-get install -y dartsdk

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN rm /etc/nginx/sites-enabled/default
ADD bin/config/daviscru.conf /etc/nginx/sites-available/daviscru.conf
RUN ln -s /etc/nginx/sites-available/daviscru.conf /etc/nginx/sites-enabled/daviscru.conf

ADD . /var/www/daviscru

WORKDIR /var/www/daviscru

RUN pub get
RUN pub build

EXPOSE 80

CMD dart bin/server.dart && nginx

#docker run -d -p 80:80 ozzieorca/daviscru