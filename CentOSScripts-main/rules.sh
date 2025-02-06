# --sport == sourceport --dport == destinationport
# Drop all input and forward
iptables -P INPUT DROP
iptables -P FORWARD DROP

# ensure loopback is good 
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -i lo -j ACCEPT

# HTTP & HTTPS rules 
iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT

# Splunk WebGUI rules 
iptables -A INPUT -i eth0 -p tcp --dport 8000 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 8000 -m state --state ESTABLISHED -j ACCEPT

# Splunk Management Port
iptables -A INPUT -i eth0 -p tcp --dport 8089 -m state --state NEW,ESTABLISHED -j ACCEPT

# Syslog traffic
iptables -A INPUT -i eth0 -p tcp --dport 9997 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 9998 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 601 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p udp --dport 514 -m state --state NEW,ESTABLISHED -j ACCEPT

# Kill SSH traffic
iptables -A INPUT -i eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j DROP
iptables -A OUTPUT -i eth0 -p tcp --sport 22 -m state --state ESTABLISHED -j DROP

# Gravwell Ports
iptables -A INPUT -i eth0 -p tcp --dport 8080 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 4023 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 9404 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 8191 -m state --state NEW,ESTABLISHED -j ACCEPT

# Allow established connections
iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
