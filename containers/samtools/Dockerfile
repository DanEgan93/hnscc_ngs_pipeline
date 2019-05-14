# A dockerfile to generate a dockerised version of samtools

## Base image
FROM alpine:3.7

# need to change to include ADD command

ENV HOME /root

RUN apk --update add wget make gcc libc-dev zlib 			zlib-dev ncurses-dev \
	&& wget -O /tmp/samtools-1.9.tar.bz2 https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 \
	&& mkdir usr/local/pipeline \
	&& chmod 755 /usr/local/pipeline \
	&& tar -C usr/local/pipeline/ -xvf tmp/samtools-1.9.tar.bz2 \
	&& cd /usr/local/pipeline/samtools-1.9/ \
	&& /usr/local/pipeline/samtools-1.9/configure --disable-bz2 --disable-lzma \
	&& make -C /usr/local/pipeline/samtools-1.9/ \
	&& cd /

RUN addgroup -S pipe \
	&& adduser -D pipeman -G pipe

USER pipeman


MAINTAINER Daniel Egan daniel.egan1@nhs.net

CMD ["/bin/sh"]
