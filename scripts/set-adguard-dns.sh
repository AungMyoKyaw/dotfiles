#!/bin/bash

# set networkname
NETWORKNAME="iPhone USB"

# set networkname
NETWORKNAME2="Wi-Fi"

# set dns servers
networksetup -setdnsservers "${NETWORKNAME}" 94.140.14.14 94.140.15.15 1.1.1.1 1.0.0.1

# get dns servers for verify
networksetup -getdnsservers "${NETWORKNAME}"

# set dns servers
networksetup -setdnsservers "${NETWORKNAME2}" 94.140.14.14 94.140.15.15 1.1.1.1 1.0.0.1

# get dns servers for verify
networksetup -getdnsservers "${NETWORKNAME2}"

echo "dns servers are now successfully updated for $NETWORKNAME2"
