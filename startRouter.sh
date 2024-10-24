#!/bin/bash

ndnsec key-gen /$CONTAINER_NAME | ndnsec cert-install -
ndnsec cert-dump -i /$CONTAINER_NAME > default.ndncert
sudo mkdir -p /usr/local/etc/ndn/keys
sudo mv default.ndncert /usr/local/etc/ndn/keys/default.ndncert

echo "Start NFD"
cp /src/nfd.conf /usr/local/etc/ndn/nfd.conf
nfd --config /usr/local/etc/ndn/nfd.conf 2> /nfd.log &
sleep 1

echo "Create faces"
for neighbor in $NEIGHBORS
do
  nfdc face create tcp4://$neighbor persistency permanent
done

echo "Start NLSR"
cp /src/$CONTAINER_NAME-nlsr.conf /usr/local/etc/ndn/nlsr.conf
nlsr -f /usr/local/etc/ndn/nlsr.conf &

while [[ $(nlsrc routing) == "Routing Table:" ]]
do
  sleep 1
done

echo "Router is ready"

sleep infinity
