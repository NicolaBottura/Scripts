#!/bin/bash

echo -e "\n"
echo "BridgeConfig - @Nicola Bottura 23 MAR 2020"
echo "P.S. run it as root user"
echo -e "\n"

ip addr flush dev veth0 scope global

# Create veth0 and veth1 virtual interfaces
for i in {0..2}; do
	sudo ip l add veth$i type veth
	sudo ip l set veth$i up
done

# Get the bridge name
brname=$(brctl show | grep -o 'kt-[a-zA-Z0-9]*')

# Add the virtual interface veth1 to the bridge
brctl addif $brname veth1

# Ask IP/PREFIX
read -p "IP address: " IP
read -p "Netmask: " NETMASK

# Add the address of the LAN you want to connect on veth0
ip addr add "${IP}/${NETMASK}" dev veth0
