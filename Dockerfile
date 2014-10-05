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

ADD build /var/www/daviscru/build

WORKDIR /var/www/daviscru/build/bin

EXPOSE 80

CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

#Run server:                    docker run --volumes-from data -d -p 80:80 ozzieorca/daviscru
#Run terminal inside server:    docker run --volumes-from data -i -t -p 80:80 ozzieorca/daviscru /bin/bash
#Create data-only container:    docker run -v /data --name data busybox echo Data-only container
#Backup:                        docker run --rm --volumes-from data-staging -v $(pwd)/backups:/backup quay.io/ozzieorca/ubuntu zip -r /backup/daviscru/daviscru-backup.zip /data
#Restore:                       docker run --rm --volumes-from data-staging -v $(pwd)/backups:/backup quay.io/ozzieorca/ubuntu unzip -o /backup/daviscru/daviscru-backup.zip -d /
#Backup MongoDB                 docker run --rm --link mongodb-dev:mongodb -v $(pwd)/backups/db:/backup quay.io/ozzieorca/mongodb mongodump --host mongodb --out /backup  --db daviscru
#Restore MongoDB                docker run --rm --link mongodb-staging:mongodb -v $(pwd)/backups/db:/backup quay.io/ozzieorca/mongodb mongorestore --drop --host mongodb /backup