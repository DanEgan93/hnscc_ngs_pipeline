# A Dockerfile to generate a dockerised version of VEP
# TODO: Fix error locate Bio/EnsEMBL/Registry.pm error!

# Base image
FROM alpine:3.7 

ENV HOME /
ENV PATH=${PATH}:/usr/local/pipeline/ensembl-vep/ensembl-vep-release-93.2 

ADD https://github.com/Ensembl/ensembl-vep/archive/release/93.2.tar.gz /tmp/

RUN apk --update add wget perl bash make gfortran pcre xz-libs libbz2 bzip2-dev ca-certificates curl-dev readline-dev xz-dev zlib-dev autoconf automake g++ gcc libx11 libxcb musl pcre-dev libxt-dev perl-utils perl-dev mysql mysql-dev glib curl git \
	&& mkdir -p /usr/local/pipeline/ensembl-vep/ \
	&& cpan install \
	&& cpan get Archive::Zip DBI DBD::mysql Set::IntervalTree JSON PerlIO::gzip HTTP::Tiny Crypt::SSL \
	&& tar xzvf tmp/93.2.tar.gz \
	&& rm tmp/93.2.tar.gz \
	&& mv ensembl-vep-release-93.2/ /usr/local/pipeline/ensembl-vep/ \
	&& cd /usr/local/pipeline/ensembl-vep/ensembl-vep-release-93.2/ \
	&& perl INSTALL.pl --AUTO a --ASSEMBLY GRCh37 
	
Maintainer Daniel Egan daniel.egan1@nhs.net

CMD ["/bin/sh"]
