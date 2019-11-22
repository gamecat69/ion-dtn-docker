#	Examples of running this image:
#docker run \
#--detach \
#-it \
#-h rx \
#-w /mnt/dtnconfig/ion-ltp-rx \
#-v "$(pwd)/configs":/mnt/dtnconfig \
#--cap-add=NET_ADMIN \
#--net ionnet \
#--ip 172.0.0.2 --name ion-rx \
#gamecat69/ion:latest

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
