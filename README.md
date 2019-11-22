#	Create a docker environment running ion on two nodes

This solution provides a network test-bed for Delay and Disruption Tolerant Networking (DTN) using the
[Interplanetary Overlay Network (ION) software distribution](https://sourceforge.net/projects/ion-dtn/) and Docker.

The test-bed can be used to run automated tests which send data from the transmitting node (tx) to the receiving node (rx).

In the example node configuration files the Licklider Transmission Protocol (LTP) is used but different node configurations can be used. To use different node configs, take a look at the ion-dtn documentation.

If required network simulation can be applied on both tx and rx nodes to simulate packet loss, latency and bandwidth restrictions.

In summary the following is provided
- A Virtual Docker network
- Dockerfile to build ION containers
- rx container
- tx container
- configs which are mounted and executed by each container
- netsim: a bash script to simulate network problems/constraints.
- test output: ion.log
- Network capture files: nnnn.pcap

# Building your own container images

**Optional, if required you can use prebuilt images available at gamecat69/ion:latest.**

**If you do use your own images, make sure to edit the docker run commands below.**

Edit the relevant Dockerfile, then edit and build using the instructions below.

Or you can edit and run build-and-push.sh in this repo.

```bash
#!/bin/bash

#	Copy in Dockerfile
cp ./ion-ltp/Dockerfile ./Dockerfile

#	Build the image
#	docker build -t <username>/<repository>:<tag>
docker build -t ion:latest .

#	Tag the image (if a tag is not already present)
# docker tag <imagename> <username>/<repositoryname>:<tag>
docker tag ion:latest gamecat69/ion:latest

#	Login to Docker Hub
docker login --username=gamecat69

#	Upload the image to Docker Hub
docker push gamecat69/ion:latest

```

# Configuring a test

Tests are configured by creating subfolders in the 'configs' folder, then mounting the subfolder during a 'docker run ...' command.

### DTN Configuration
Edit node.conf in your respective config folder.

### Test Configuration
Edit dtn-start.sh in your respective config folder.

### Applying network simulation
A bash script 'netsim' has been provided to apply network simmulation. If you want to add network simulation using netsim, simply edit the 'netsim' command in each dtn-start.sh file.

#	Executing a test

**Todo: Update to use docker compose**

###	Create the ion network
```bash
docker network create --subnet=172.0.0.0/24 ionnet
```

### Stop and delete any previous containers if needed
```bash
docker stop ion-tx; docker rm ion-tx
docker stop ion-rx; docker rm ion-rx
```
#	Create and run rx container

```bash
docker run \
--detach \
-it \
-h rx \
-w /mnt/dtnconfig/ion-ltp-rx \
-v "$(pwd)/configs":/mnt/dtnconfig \
--cap-add=NET_ADMIN \
--net ionnet \
--ip 172.0.0.2 --name ion-rx \
gamecat69/ion:latest
```

#	Create and run tx container
```bash
docker run \
--detach \
-it \
-h tx \
-w /mnt/dtnconfig/ion-ltp-tx \
-v "$(pwd)/configs":/mnt/dtnconfig \
--cap-add=NET_ADMIN \
--net ionnet \
--ip 172.0.0.3 --name ion-tx \
gamecat69/ion:latest
```
#	Viewing test results

The results of the tests can be seen in many locations.

- **ION Logs:** configs/-node-/ion.log
- **Network Captures:** configs/-node-/-node-netcap.pcap
- **Docker activity:** docker logs -container-id- *(Get container id when starting or run 'docker ps --all')*

#	Useful commands

###	Start and attach containers
If the containers are not started, start and attach

```bash
docker start ion-rx -i
docker start ion-tx -i
```

###	Attach to an already started container
```bash
docker attach ion-rx
docker attach ion-tx
```

### Run a container interactively to troubleshoot using a shell in the container:
```bash
docker run \
-it --entrypoint /bin/bash \
-h rx \
-w /mnt/dtnconfig/ion-ltp-rx \
-v "$(pwd)/configs":/mnt/dtnconfig \
--cap-add=NET_ADMIN \
--net ionnet \
--ip 172.0.0.2 --name ion-rx \
gamecat69/ion:latest
```

### Running Manual tests

Some useful commands if you would like to run manual tests. The Dockerfiles will obviously need to be updated to use this method.

#####	rx:
tshark -i eth0 -f "not arp and not icmp" -w netcap.pcap &
ionstart -I /mnt/dtnconfig/$HOSTNAME.conf '../../system_up -i "p 30" -b "p 30"'
bprecvfile ipn:3.1

#####	tx:
ionstart -I /mnt/dtnconfig/$HOSTNAME.conf '../../system_up -i "p 30" -b "p 30"'
bpsendfile ipn:1.1 ipn:3.1 payload.txt
