#!/bin/bash
# https://github.com/davift/TorTunnel
# Verion 1

# Root
if [ $(id -u) -ne 0 ];
then
    echo "Run as root or use 'sudo'"
    exit 1
fi

## Options
if [ $# -eq 0 ]
then
    echo ''
    echo "Usage: tortunnel [--backup] [--install|--start] [--restore|--stop] [--refresh] [interface]"
    echo ''
    echo "Required:"
    echo " --backup             backup the original system's configuration before installation"
    echo " --install, --start   make changes to the system's configuration and start tunneling"
    echo " --restore, --stop    restore the backup with original system's configuration"
    echo " --refresh            request Tor to acquire a new connection"
    echo ''
    echo "Optional:"
    echo " interface            defines what LAN interface to accept traffic on (requires --start)"
    echo ''
    exit 0
fi

# Install Tor if not present
(which tor > /dev/null) || (apt update && apt install tor -y)
# Install Curl if not present
(which curl > /dev/null) || (apt update && apt install curl -y)

if ip link show "$2" > /dev/null 2>&1; then
    interface="$2"
fi

## Selection
while test $# -gt 0;
do
    case "$1" in
        --backup)
            # Backup Tor
            cat /etc/tor/torrc > /etc/tor/torrc.bak
            # Backup Resolution
            cat /etc/resolv.conf > /etc/resolv.conf.bak
            # Backup Routes
            iptables-save > /etc/iptables.rules.bak
            # Backup System Parameters
            sysctl -a > /etc/sysctl.conf.bak
            echo 'Backup completed!'
            exit 1
            ;;
        --install|--start)
            # Custom Tor
            cat torrc > /etc/tor/torrc
            systemctl stop tor ; sleep 2s ; systemctl start tor
            # Overwrite Resolution (may not persist across boot)
            cat resolv.conf > /etc/resolv.conf
            # Overwrite Routes (will not persist across boot)
            ./iptables.rules.sh $interface
            # Overwrite System Parameters (will not persist across boot)
            ./sysctl.conf.sh > /dev/null
            # Check Connection
            sleep 3s
            echo -n 'PublicIP ' ; curl http://ip.me || echo 'unknown'
            echo -n 'IsTor? ' ; curl -s https://check.torproject.org/api/ip | jq -r '.IsTor' || echo 'unknown'
            exit 1
            ;;
        --restore|--stop)
            # Restore System Parameters
            sysctl -p /etc/sysctl.conf.bak &> /dev/null
            # Restore Routes
            iptables -F ; iptables -t nat -F ; iptables-restore < /etc/iptables.rules.bak
            # Restore Tor
            cat /etc/tor/torrc.bak > /etc/tor/torrc
            systemctl stop tor ; sleep 2s ; systemctl start tor
            # Restore Resolution
            cat /etc/resolv.conf.bak > /etc/resolv.conf
            echo 'Restauration completed!'
            exit 1
            ;;
        --refresh)
            # Restarting Tor
            systemctl stop tor ; sleep 2s ; systemctl start tor
            sleep 3s
            echo -n 'PublicIP ' ; (curl http://ip.me 2> /dev/null) || echo 'unknown'
            echo -n 'IsTor? ' ; curl -s https://check.torproject.org/api/ip | jq -r '.IsTor' || echo 'unknown'
            exit 1
            ;;
        *)
            echo 'invalid option'
            exit 1
            ;;
    esac
done
exit 0
