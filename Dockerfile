FROM alpine:3.9

ARG PDNS_VER="4.1.6"

RUN apk -U add --virtual deps \
        autoconf automake py3-virtualenv \
        git libtool gcc g++ bison flex \
        libressl-dev ragel boost-dev make \
        sqlite-dev yaml-cpp-dev && \
    apk add libressl libgcc libstdc++ \
        yaml-cpp sqlite-libs boost-program_options && \
    cd ~ && \
	git clone https://github.com/PowerDNS/pdns && \
	cd pdns && \
	git checkout tags/auth-$PDNS_VER && \
    ./bootstrap && \
    ./configure --prefix=/opt/pdns \
        --with-modules="gsqlite3 bind" && \
    make -j$(nproc) && \
    make install && \
    apk del --purge deps && \
    rm -rf ~/* && \
    rm -rf /opt/pdns/bin/zone2*

ENV PATH=${PATH}:/opt/pdns/sbin:/opt/pdns/bin
CMD pdns_server --disable-syslog --guardian=yes --daemon=no
