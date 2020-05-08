#!/bin/bash
simulatorip=$(ping -c 1 aws-metadata-simulator | grep "bytes from" | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
attackerip=$(ping -c 1 attackerserver | grep "bytes from" | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")

# save the container names before setting ip forwarding
echo $simulatorip aws-metadata-simulator >> /etc/hosts
echo $attackerip attackerserver >> /etc/hosts

# The following will mess up docker's container name resolution.
iptables -t nat -A OUTPUT -p tcp -d 169.254.169.254 --dport 80 -j DNAT --to-destination $simulatorip:8111
