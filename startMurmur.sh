#!/bin/bash

# Configure IP
IP=$(awk 'NR==1 {print $1}' /etc/hosts)
echo "Detected IP is $IP"
sed -i.bak 's|IPv4|'"$IP"'|' /etc/murmur.ini

# Launch Murmur
/opt/murmur/murmur.x86 -fg -v
