#!/bin/bash
simulatorip=$(busybox nslookup $SIMULATOR_HOSTNAME | grep -A 1 $SIMULATOR_HOSTNAME | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
err=$?
if [ $err -eq 1 ]; then
    simulatorip=$(ping -c 1 $SIMULATOR_HOSTNAME | grep "bytes from" | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
fi
attackerip=$(busybox nslookup $ATTACKER_HOSTNAME | grep -A 1 $ATTACKER_HOSTNAME | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
err=$?
if [ $err -eq 1 ]; then
    attackerip=$(ping -c 1 $ATTACKER_HOSTNAME | grep "bytes from" | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
fi


cat /etc/hosts > /etc/hosts.bak
# save the container names before setting ip forwarding
echo $simulatorip aws-metadata-simulator-flaskxxe >> /etc/hosts
echo $attackerip attackerserver-flaskxxe >> /etc/hosts

# The following will mess up docker's container name resolution. choose iptables-legacy if iptables --list shows warning of iptables-legacy.
# iptables -t nat -A OUTPUT -p tcp -d 169.254.169.254 --dport 80 -j DNAT --to-destination $simulatorip:8111
iptables-legacy -t nat -A OUTPUT -p tcp -d 169.254.169.254 --dport 80 -j DNAT --to-destination $simulatorip:8111
