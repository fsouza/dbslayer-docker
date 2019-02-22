FROM alpine:3.9 AS build

ENV DBSLAYER_VERSION d19e489ef221ebe0b097b8755e6fe32b8b4a61bc

RUN apk add --no-cache build-base apr-dev mariadb-dev apr-util-dev
ADD https://github.com/derekg/dbslayer/archive/$DBSLAYER_VERSION.tar.gz /dbslayer.tar.gz
RUN mkdir /dbslayer
RUN tar --strip 1 -C /dbslayer -xzf /dbslayer.tar.gz

WORKDIR /dbslayer
RUN     ./configure
RUN     make

FROM alpine:3.9
RUN apk add --no-cache apr mariadb-client apr-util
ADD my.cnf.template /etc/my.cnf.template
ADD entrypoint.sh /entrypoint.sh
COPY --from=build /dbslayer/server/dbslayer /usr/bin/dbslayer

ENV MYSQL_PORT 3306

ENTRYPOINT ["/entrypoint.sh"]
