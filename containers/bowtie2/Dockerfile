# A dockerfile to generate a dockerised version of Bowtie2

## Base image
FROM centos


ENV HOME /root
ENV PATH=${PATH}:/bowtie2-2.3.5-linux-x86_64/


RUN yum -y install tbb-devel.x86_64 wget unzip perl \
	&& wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.5/bowtie2-2.3.5-linux-x86_64.zip \
	&& unzip bowtie2-2.3.5-linux-x86_64.zip


MAINTAINER Daniel Egan daniel.egan1@nhs.net

CMD ["/bin/sh"]
