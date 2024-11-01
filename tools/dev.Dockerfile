from docker.io/golang:1.23.2-bookworm

RUN set -x; \
    apt-get -y update && \
    apt-get -y install build-essential libpcre3 libpcre3-dev;

WORKDIR "/app/src"
CMD [ "/bin/bash " ]