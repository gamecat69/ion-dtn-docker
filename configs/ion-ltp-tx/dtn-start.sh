#!/bin/bash

#	ion-tx

#	Start netwok simulation
# Add netsim command here if needed
chmod +x netsim
./netsim 0.0001 500ms 125kbit

#SIZE=1024b # size of payload
NUMBUNDLES=10	  # number of payload bundles to send
WAITTRN=0.5 #	Num seconds to wait after each send
#PAYLOAD=payload-1024b
PAYLOAD=payload-64k
SENDCMD="bpsendfile ipn:1.1 ipn:3.1 $PAYLOAD"
#SENDCMD="bpdriver $NUMBUNDLES ipn:1.1 ipn:3.1 -2048"
COUNT=1	  #	Init sending for loop variable

#	Remove previous logfile
rm ion.log

#	Create payload file
#rm payload.txt
#mkfile $SIZE payload.txt
#	Start ion
ionstart -I node.conf '../../system_up -i "p 30" -b "p 30"'
sleep 2

#	Send the file
echo ---------------------------------
echo Sending payload: $PAYLOAD
echo ---------------------------------

for ((i=1;i<=NUMBUNDLES;i++)); do

    NOW=$(date "+%F %T")
    echo "[$NOW] ($COUNT) $SENDCMD"
    eval $SENDCMD
    sleep $WAITTRN

    let "COUNT++"

done
