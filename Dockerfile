FROM alpine:3.7

ARG PDNS_VER="4.1.2"

RUN apk -U add --virtual deps \
        autoconf automake py2-virtualenv \
        git libtool gcc g++ bison flex \
        openssl-dev ragel boost-dev make \
        sqlite-dev geoip-dev yaml-cpp-dev && \
    apk add libcrypto1.0 libgcc libstdc++ \
        yaml-cpp geoip sqlite-libs boost-program_options && \
    cd ~ && \
    wget https://github.com/PowerDNS/pdns/archive/auth-$PDNS_VER.tar.gz && \
    tar xf auth-$PDNS_VER.tar.gz && cd ~/pdns-auth-$PDNS_VER/ && \
    ./bootstrap && \
    ./configure --prefix=/opt/pdns \
        --with-modules="gsqlite3 geoip" && \
    make -j$(nproc) && \
    make install && \
    apk del --purge deps && \
    rm -rf ~/* && \
    rm -rf /opt/pdns/bin/zone2*

CMD /opt/pdns/sbin/pdns_server
