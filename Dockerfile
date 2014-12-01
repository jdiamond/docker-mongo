FROM debian:wheezy

RUN ver='2.6.5'; \
    url="https://fastdl.mongodb.org/src/mongodb-src-r$ver.tar.gz"; \
    md5='a6ba36e84c291a3e174c36138a470fd1'; \
    deps='curl ca-certificates build-essential libssl-dev scons'; \
    set -x && \
    groupadd -r mongodb && \
    useradd -r -g mongodb mongodb && \
    apt-get update && \
    apt-get install -y $deps --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    cd /tmp && \
    curl -sSL "$url" -o mongo.tgz && \
    echo "$md5 *mongo.tgz" | md5sum -c - && \
    mkdir mongo && \
    tar -xf mongo.tgz -C mongo --strip-components 1 && \
    cd mongo && \
    scons core tools install --64 --ssl && \
    cd debian && \
    chmod +x mongodb-org-server.postinst && \
    ./mongodb-org-server.postinst configure && \
    cd /tmp && \
    rm -rf mongo mongo.tgz && \
    apt-get purge -y --auto-remove $deps
