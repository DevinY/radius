FROM ubuntu:21.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends freeradius freeradius-mysql  freeradius-utils vim  net-tools wget mysql-client

EXPOSE 1812/udp 1813/udp

CMD ["/usr/sbin/freeradius","-X"]
