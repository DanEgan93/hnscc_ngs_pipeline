# A docker file to generate a dockerised version of FastQC

## Base image
FROM python:3.7.0-alpine3.7

ENV HOME /root


RUN apk --update add openjdk7-jre \
	&& apk add wget \
	&& apk add perl \
	&& apk add ttf-dejavu \
	&& wget -O /tmp/fastqc_v0.11.2.zip https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.7.zip \
	&& mkdir /usr/local/pipeline/ \
	&& unzip /tmp/fastqc_v0.11.2.zip -d /usr/local/pipeline \
	&& chmod 755 /usr/local/pipeline/FastQC/fastqc

RUN addgroup -S pipe \
	&& adduser -D pipeman -G pipe


# TODO- fix file not found permission error
# USER pipeman
# MAINTAINER Daniel Egan daniel.egan1@nhs.net

CMD ["/bin/sh"]
