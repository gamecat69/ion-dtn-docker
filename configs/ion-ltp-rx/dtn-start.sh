#!/bin/bash

#	ion-rx

#	Remove old logfile and recieved files
rm ion.log
rm testfile*

id

#	Start netwok simulation
# Add netsim command here if needed
chmod +x netsim
./netsim 0.0001 500ms 125kbit

#	Start capturing network traffic
#	tshark -i eth0 -f "not arp and not icmp and not icmp6" -w netcap.pcap &
tshark -i eth0 -f "port 1113" -w rx-netcap.pcap &

#	Start ION on node
ionstart -I node.conf '../../system_up -i "p 30" -b "p 30"'

#	Listen for bundles
bprecvfile ipn:3.1
