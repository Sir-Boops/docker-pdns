FROM alpine:3.7

ARG PDNS_VER="4.1.1"

RUN addgroup -S pdns && \
	adduser -S -G pdns pdns

RUN apk -U add autoconf automake py2-virtualenv \
		git libtool gcc g++ bison flex \
		openssl-dev ragel boost-dev make sqlite-dev && \
	cd ~ && wget https://github.com/PowerDNS/pdns/archive/auth-$PDNS_VER.tar.gz && \
	tar xf auth-$PDNS_VER.tar.gz && cd ~/pdns-auth-$PDNS_VER/ && \
	./bootstrap && \
	./configure --prefix=/opt/pdns \
		--with-modules="gsqlite3" && \
	make -j$(nproc) && \
	make install && \
	apk del autoconf automake git \
		libtool gcc g++ bison flex \
		openssl-dev ragel boost-dev make \
		py2-virtualenv sqlite-dev && \
	apk add libcrypto1.0 libgcc libstdc++ sqlite-libs && \
	rm -rf ~/* && rm -rf /opt/pdns/bin/zone2*

CMD /opt/pdns/sbin/pdns_server
