FROM ubuntu
MAINTAINER Scotty Waggoner <ozzieorca@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y curl wget vim git
RUN apt-get install -y software-properties-common python-software-properties

RUN apt-get install -y supervisor
RUN apt-get install -y nginx
RUN apt-add-repository ppa:hachre/dart
RUN apt-get update
RUN apt-get install -y dartsdk

ADD bin/config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
ADD bin/config/nginx-daviscru.conf /etc/nginx/sites-available/nginx-daviscru.conf
RUN ln -s /etc/nginx/sites-available/nginx-daviscru.conf /etc/nginx/sites-enabled/nginx-daviscru.conf

WORKDIR /var/www/daviscru
ADD pubspec.yaml /var/www/daviscru/
ADD pubspec.lock /var/www/daviscru/
ADD lib /var/www/daviscru/lib
RUN pub get
ADD bin /var/www/daviscru/bin
ADD web /var/www/daviscru/web
ADD build /var/www/daviscru/build

WORKDIR /var/www/daviscru/bin

EXPOSE 80

CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

#docker run -d -p 80:80 ozzieorca/daviscru
#docker stop $(docker ps -a -q);  docker rm $(docker ps -a -q); docker run -d -p 80:80 ozzieorca/daviscru
#docker stop $(docker ps -a -q);  docker rm $(docker ps -a -q); docker run -d -i -t -p 80:80 ozzieorca/daviscru /bin/bash; docker attach $(docker ps -q)