# A dockerfile to generate a dockerised version of bwa

## Base image
FROM alpine:3.7

ENV HOME /root

RUN apk --update add gcc libc-dev zlib zlib-dev wget make\
	&& wget -O /tmp/bwa-0.7.16a.tar.bz2 https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.16a.tar.bz2  \
	&& tar -xvf /tmp/bwa-0.7.16a.tar.bz2 \
	&& mkdir /usr/local/pipeline \
	&& chmod 755 /usr/local/pipeline \
	&& mv /bwa-0.7.16a /usr/local/pipeline \
	&& rm -rf tmp/bwa-0.7.16a.tar.bz2 \
	&& make -C /usr/local/pipeline/bwa-0.7.16a/

RUN addgroup -S pipe \
	&& adduser -D pipeman -G pipe

USER pipeman



MAINTAINER Daniel Egan daniel.egan1@nhs.net

CMD ["/bin/sh"]
