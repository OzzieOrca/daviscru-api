FROM datadog/docker-dd-agent
MAINTAINER Scotty Waggoner <ozzieorca@gmail.com>

ADD nginx.yaml /etc/dd-agent/conf.d/nginx.yaml

#Docker Build
#cd ~/docker-builder/datadog && docker build -t quay.io/ozzieorca/datadog . && docker push quay.io/ozzieorca/datadog; cd