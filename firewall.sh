#!/bin/sh

#################################################################
# CHECKING TO SEE IF USER IS ROOT/SUDO
#################################################################
#if [[ $EUID -ne 0 ]]; then
#       echo "This script must be run as root" 
#          exit 1
#      fi
#################################################################


#___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|__
#_|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|
#___|___|___|___|___|__FIREWALL RULES___|___|___|___|___|___|___|___|___|___|___|__
#_|___|___|___|___|___|__FOR PYTHON___|___|___|___|___|___|___|___|___|___|___|___|
#___|___|___|___|___|___|DOCKER MANAGER_|___|___|___|___|___|___|___|___|___|___|__
#_|___|___|___|___|___|___|_WEBAPP|___|___|___|___|___|___|___|___|___|___|___|___|
#___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|__
#_|___|___|___|___|___|___|___|___|___|by_|___|___|___|___|___|___|___|___|___|___|
#___|___|___|___|___|___|___|___|__Brandon Geraci___|___|___|___|___|___|___|___|__
#_|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|
#___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|__
#_|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|
#___|___|___|___|___|Allowing traffic from outside world ___|___|___|___|___|___|___
#_|___|___|___|___|___|___|___|___|___to docker container with ip address's 172.*.*.*
#===========================>>__|___|___|___|___|___|___|___|___|___|___|___|___|__
#_|___|__WORLD 0.0.0.0|___-->>|___|__DOCKER CONTAINER 172.*.*.* port 6901_|___|___|
iptables -A DOCKER-USER -p tcp --dport 6901 -m iprange --dst-range 172.0.0.0-172.255.255.255 -j ACCEPT
iptables -A DOCKER-USER -p udp --dport 6901 -m iprange --dst-range 172.0.0.0-172.255.255.255 -j ACCEPT
#_|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|
#___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|__
#_|___|___|___|_Allowing traffic from docker container with ip address's 172.*.*.*
#___|___|___|___|___|___|___|___|to the outside world
#                          <<=============================
#        WORLD 0.0.0.0     <<--      DOCKER CONTAINER 172.*.*.* port 6901
iptables -A DOCKER-USER -p tcp --sport 6901 -m iprange --src-range 172.0.0.0-172.255.255.255 -j ACCEPT
iptables -A DOCKER-USER -p udp --sport 6901 -m iprange --src-range 172.0.0.0-172.255.255.255 -j ACCEPT
iptables -A DOCKER-USER -m iprange --dst-range 172.0.0.0-172.255.255.255 -j DROP
iptables -A DOCKER-USER -m iprange --src-range 172.0.0.0-172.255.255.255 -j DROP
iptables -A DOCKER-USER -m state --state ESTABLISHED,RELATED -j ACCEPT
