#!/bin/bash

# set networkname
NETWORKNAME="iPhone USB"

# set networkname
NETWORKNAME2="Wi-Fi"

# set dns servers
networksetup -setdnsservers "${NETWORKNAME}" 127.0.0.1 172.17.0.3 176.103.130.130 176.103.130.131 1.1.1.1 1.0.0.1

# get dns servers for verify
networksetup -getdnsservers "${NETWORKNAME}"

# set dns servers
networksetup -setdnsservers "${NETWORKNAME2}" 127.0.0.1 172.17.0.3 176.103.130.130 176.103.130.131 1.1.1.1 1.0.0.1

# get dns servers for verify
networksetup -getdnsservers "${NETWORKNAME2}"

echo "dns servers are now successfully updated for $NETWORKNAME2"
