# A dockerfile to generate a dockerised version of Trimmomatic

## Base image
FROM alpine:3.7

ENV HOME /root

RUN apk --update add openjdk7-jre \
	&& apk add wget \
	&& wget -O /tmp/trimmomatic-0.38.zip www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.38.zip \
	&& mkdir /usr/local/pipeline \
	&& unzip /tmp/trimmomatic-0.38.zip -d /usr/local/pipeline \
	&& chmod 755 /usr/local/pipeline/

 
RUN addgroup -S pipe \
	&& adduser -D pipeman -G pipe

# TODO- fix file not found permission error
# USER pipeman

MAINTAINER Daniel Egan daniel.egan1@nhs.net

CMD ["/bin/sh"]

