FROM nginx:1.19-alpine

SHELL ["/bin/ash", "-oeux", "pipefail", "-c"]

# TimeZone
ARG TZ

RUN set -eux && \
    apk add --no-cache tzdata && \
    cp -r /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone

RUN apk update && \
  apk add --update --no-cache --virtual=.build-dependencies g++


# nginx config file
COPY ship/docker/maintenance-html/default.conf /etc/nginx/conf.d/default.conf

# copy html
COPY ship/docker/maintenance-html/public  /usr/share/nginx/html


WORKDIR /usr/share/nginx/html

EXPOSE 80
