#	Building this image from the directory containing this Dockerfile:
#	docker build -t gamecat69/ion:v1 .

#	Examples of running this image:
#	docker run --detach --net ionnet --ip 172.0.0.2 --name ion-rx -h rx -w /mnt/dtnconfig/ion-ltp-rx -v ~/Nextcloud/ForDropbox/LTP/Docker/configs:/mnt/dtnconfig -it gamecat69/ion:v3
#	docker run --detach --net ionnet --ip 172.0.0.3 --name ion-tx -h tx -w /mnt/dtnconfig/ion-ltp-tx -v ~/Nextcloud/ForDropbox/LTP/Docker/configs:/mnt/dtnconfig -it gamecat69/ion:v3

FROM ubuntu:14.04
MAINTAINER Nik Ansell
LABEL Description="This image is used to run ION-LTP atop Ubuntu 14.04"

#	Install pre-requisites and tools
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
git gcc make wget mercurial automake autoconf patch nmap tcl libc6-dev nano tshark tcl-dev libdb-dev libssl-dev g++ \
--no-install-recommends
RUN apt-get clean

#	Download, extract and patch source files
RUN  mkdir -p /usr/local/src/ion
WORKDIR /usr/local/src/ion
RUN  wget http://downloads.sourceforge.net/project/ion-dtn/ion-3.7.0.tar.gz --no-check-certificate \
  && tar -zxvf ion-3.7.0.tar.gz \
  && cd ion-3.7.0 && ./configure && make -j 10 && make install \
  && ldconfig

#	Create the base working directory
RUN mkdir -p /mnt/dtnconfig

EXPOSE 1113
CMD ./dtn-start.sh
