FROM ubuntu:14.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y curl build-essential libssl-dev scons

RUN curl -o /tmp/mongo.tgz -SL 'https://fastdl.mongodb.org/src/mongodb-src-r2.6.4.tar.gz' && \
    mkdir /tmp/mongo && \
    tar -xf /tmp/mongo.tgz -C /tmp/mongo --strip-components 1 && \
    cd /tmp/mongo && \
    scons core tools install --64 --ssl && \
    cd debian && \
    chmod +x mongodb-org-server.postinst && \
    ./mongodb-org-server.postinst configure && \
    rm -rf /tmp/mongo && \
    rm /tmp/mongo.tgz

USER mongodb
