# Clear iptables rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Create NAT
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
iptables --append FORWARD --in-interface wlan1 -j ACCEPT
iptables -N internet -t mangle
iptables -t mangle -A PREROUTING -j internet

# Mark package
iptables -t mangle -A internet -j MARK --set-mark 99
# Forward package to captive portal server
iptables -t nat -A PREROUTING -m mark --mark 99 -p tcp --dport 80 -j DNAT --to-destination 192.168.22.1
#iptables -t filter -A FORWARD -m mark --mark 99 -j DROP

# Activate forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
