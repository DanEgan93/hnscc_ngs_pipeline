# A Docker file to generate a Dockerised version of VT

# Base image
FROM alpine:3.7

ENV HOME /
ENV PATH=${PATH}:/usr/local/pipeline/vt/vt-0.57721/

ADD https://github.com/atks/vt/archive/0.57721.tar.gz /tmp/

RUN apk --update add openjdk8 wget perl bash git make gfortran pcre xz-libs libbz2 bzip2-dev ca-certificates curl-dev readline-dev xz-dev zlib-dev autoconf automake g++ gcc libx11 libxcb musl pcre-dev libxt-dev libressl-dev \
	&& mkdir -p /usr/local/pipeline/vt/ \
	&& tar -xvzf tmp/0.57721.tar.gz \
	&& rm tmp/0.57721.tar.gz \
	&& mv vt-0.57721/ /usr/local/pipeline/vt/ \
	&& cd /usr/local/pipeline/vt/vt-0.57721/ \
	&& make 

MAINTAINER Daniel Egan daniel.egan1@nhs.net

CMD ["/bin/sh"]