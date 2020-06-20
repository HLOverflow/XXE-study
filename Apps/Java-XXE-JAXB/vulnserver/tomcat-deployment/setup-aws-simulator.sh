#!/bin/bash
simulatorip=$(ping -c 1 aws-metadata-simulator-jaxb | grep "bytes from" | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}") 
attackerip=$(ping -c 1 attackerserver-jaxb | grep "bytes from" | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")

# save the container names before setting ip forwarding
echo $simulatorip aws-metadata-simulator-jaxb >> /etc/hosts
echo $attackerip attackerserver-jaxb >> /etc/hosts

# The following will mess up docker's container name resolution. choose iptables-legacy if iptables --list shows warning of iptables-legacy.
# iptables -t nat -A OUTPUT -p tcp -d 169.254.169.254 --dport 80 -j DNAT --to-destination $simulatorip:8111
iptables-legacy -t nat -A OUTPUT -p tcp -d 169.254.169.254 --dport 80 -j DNAT --to-destination $simulatorip:8111
