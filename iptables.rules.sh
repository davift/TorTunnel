#!/bin/bash
# TorTunnel Routes

## Wiping existing rules
iptables -F
iptables -t nat -F

# LAN inbound traffic
interface=$1
if [ -n "$interface" ]; then
  ## Routes TCP inbound traffic
  iptables -t nat -A PREROUTING -i $interface -p tcp --syn -j REDIRECT --to-ports 9040
  ## DNS for inbound traffic
  iptables -t nat -A PREROUTING -i $interface -p udp --dport 53 -j REDIRECT --to-ports 9053
  iptables -t nat -A PREROUTING -i $interface -p tcp --dport 53 -j REDIRECT --to-ports 9053
  # Sinkholing UDP and ICMP
  iptables -t nat -A PREROUTING -i $interface -p udp -j REDIRECT --to-ports 9040
  iptables -t nat -A PREROUTING -i $interface -p icmp -j REDIRECT --to-ports 9040
fi

# Local system outbound traffic
## NAT
iptables -t nat -A OUTPUT -m owner --uid-owner debian-tor -j RETURN
## DNS
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 9053
iptables -t nat -A OUTPUT -p tcp --dport 53 -j REDIRECT --to-ports 9053
## DNS address space mapping 10.192.0.0/10
iptables -t nat -A OUTPUT -p tcp -d 10.192.0.0/10 -j REDIRECT --to-ports 9040
iptables -t nat -A OUTPUT -p udp -d 10.192.0.0/10 -j REDIRECT --to-ports 9040
## Excluded networks
iptables -t nat -A OUTPUT -d 10.0.0.0/8 -j RETURN
iptables -t nat -A OUTPUT -d 127.0.0.0/9 -j RETURN
iptables -t nat -A OUTPUT -d 172.16.0.0/12 -j RETURN
iptables -t nat -A OUTPUT -d 192.168.0.0/16 -j RETURN
iptables -t nat -A OUTPUT -d 127.128.0.0/10 -j RETURN
## Allow LAN
iptables -A OUTPUT -d 10.0.0.0/8 -j ACCEPT
iptables -A OUTPUT -d 127.0.0.0/9 -j ACCEPT
iptables -A OUTPUT -d 172.16.0.0/12 -j ACCEPT
iptables -A OUTPUT -d 192.168.0.0/16 -j ACCEPT
iptables -A OUTPUT -d 127.128.0.0/10 -j ACCEPT
## Route redirect
iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040
iptables -t nat -A OUTPUT -p udp -j REDIRECT --to-ports 9040
iptables -t nat -A OUTPUT -p icmp -j REDIRECT --to-ports 9040
## Accept established outbound connections
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
## Accept established inbound connections
iptables -A INPUT -i enp1s0 -m state --state ESTABLISHED,RELATED -j ACCEPT
## Allow only Tor output
iptables -A OUTPUT -m owner --uid-owner debian-tor -j ACCEPT
iptables -A OUTPUT -j REJECT
