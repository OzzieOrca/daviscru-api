FROM ubuntu
MAINTAINER Scotty Waggoner <ozzieorca@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y curl wget tree vim nano git
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

RUN curl -O https://www.loggly.com/install/configure-linux.sh
RUN bash configure-linux.sh -a ozzieorca -t 3602f4dd-31a6-4d6c-bb3a-510b93005227 -u OzzieOrca

RUN wget -q -O - https://www.loggly.com/install/configure-syslog.py | sudo python - setup --auth 3602f4dd-31a6-4d6c-bb3a-510b93005227 --account ozzieorca
ADD bin/config/21-nginx-loggly.conf /etc/rsyslog.d/21-nginx-loggly.conf
RUN service rsyslog restart

ADD build /var/www/daviscru/build

WORKDIR /var/www/daviscru/build/bin

EXPOSE 80

CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

#Run server:                    docker run --volumes-from data -d -p 80:80 ozzieorca/daviscru
#Run terminal inside server:    docker run --volumes-from data -i -t -p 80:80 ozzieorca/daviscru /bin/bash
#Create data-only container:    docker run -v /data --name data busybox echo Data-only container
#Backup:                        docker run --volumes-from data -v $(pwd)/backups:/backup busybox tar cvf /backup/daviscru/daviscru-backup.tar /data
#Restore:                       docker run --volumes-from data -v $(pwd)/backups:/backup busybox tar xvf /backup/daviscru/daviscru-backup.tar