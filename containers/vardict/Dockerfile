# A docker file to generate a dockerised version of VarDictJava 
# Need to specify version of the VarDictJava to be pulled from git 
# Make check error see note on TZ specification

## Base image
FROM alpine:3.7

ENV HOME /root
ENV PATH=${PATH}:/usr/local/pipeline/VarDict/VarDictJava-1.5.1/build/install/VarDict/bin
ENV PATH=${PATH}:/tmp/R-3.5.0/bin
ENV PATH=${PATH}:/opt/gradle/gradle-3.4.1/bin 

ADD https://cran.r-project.org/src/base/R-3/R-3.5.0.tar.gz /tmp/


RUN apk --update add openjdk8 wget perl bash git make gfortran pcre xz-libs libbz2 bzip2-dev ca-certificates curl-dev readline-dev xz-dev zlib-dev autoconf automake g++ gcc libx11 libxcb musl pcre-dev libxt-dev \
	&& cd /tmp \
	&& tar xzvf R-3.5.0.tar.gz \
	&& rm R-3.5.0.tar.gz \
	&& cd R-3.5.0/ \ 
	&& ./configure --sysconfdir=/etc --mandir=/usr/share/man --localstatedir=/var --disable-java --without-x \
	&& make \
	&& make install \
	&& cd / \
	&& wget https://services.gradle.org/distributions/gradle-3.4.1-bin.zip \
	&& mkdir -p /opt/gradle \
	&& unzip /gradle-3.4.1-bin.zip -d opt/gradle/ \
	&& rm gradle-3.4.1-bin.zip \
  	&& git clone --recursive https://github.com/AstraZeneca-NGS/VarDictJava.git \
	&& mkdir -p /usr/local/pipeline/VarDict/ \
	&& mv VarDictJava/ /usr/local/pipeline/VarDict/ \
    && cd /usr/local/pipeline/VarDict/VarDictJava/ \
	&& ./gradlew installDist \
	&& cd / 


MAINTAINER Daniel Egan daniel.egan1@nhs.net

CMD ["/bin/sh"]
