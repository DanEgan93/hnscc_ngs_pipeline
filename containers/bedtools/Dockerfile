# A Dockerfile to generate a Dockerised version of Bedtools v2.25

# Base image
From alpine:3.7

ENV HOME / 
ENV PATH=${PATH}:/usr/local/pipeline/bedtools/bedtools2/bin

ADD https://github.com/arq5x/bedtools2/releases/download/v2.25.0/bedtools-2.25.0.tar.gz /

RUN apk --update add openjdk8 wget perl bash git make gfortran pcre xz-libs libbz2 bzip2-dev ca-certificates curl-dev readline-dev xz-dev zlib-dev autoconf automake g++ gcc libx11 libxcb musl pcre-dev libxt-dev libressl-dev python3 \
	&& if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi \
	&& mkdir -p usr/local/pipeline/bedtools/ \
	&& tar -zxvf bedtools-2.25.0.tar.gz \
	&& rm bedtools-2.25.0.tar.gz \
	&& mv bedtools2/ /usr/local/pipeline/bedtools/ \
	&& cd /usr/local/pipeline/bedtools/bedtools2/ \
	&& make 


MAINTAINER Daniel Egan daniel.egan1@nhs.net

CMD ["/bin/sh"]

