# TorTunnel

This script tunnels all system traffic through Tor and was designed and tested on Ubuntu 24.04 LTS.

No more SOCKS configuration per application or `proxychains`. Even DNS is tunneled!

<video src="[https://your-hosted-link-to-video.mp4](https://youtu.be/uK5m3gBD9xM)" controls width="600"></video>

Kali Linux \
[![YouTube Video Title](https://img.youtube.com/vi/ike--N4JZ5I/0.jpg)](https://www.youtube.com/watch?v=ike--N4JZ5I)

Ubuntu \
[![YouTube Video Title](https://img.youtube.com/vi/uK5m3gBD9xM/0.jpg)](https://www.youtube.com/watch?v=uK5m3gBD9xM)

## Usage

```
Usage: tortunnel [--backup] [--install|--start] [--restore|--stop] [--refresh] [interface]

Required:
 --backup             backup the original system's configuration before installation
 --install, --start   make changes to the system's configuration and start tunneling
 --restore, --stop    restore the backup with original system's configuration
 --refresh            request Tor to acquire a new connection

Optional:
 interface            defines what LAN interface to accept traffic on (requires --start)
```

The first step is to back up the original configuration for later restoration.

```
sudo ./tortunnel.sh --backup
```

Then, start tunneling traffic through Tor.

```
sudo ./tortunnel.sh --start
```

Optionally, start tunneling traffic through Tor including inbound requests on a given interface.

```
sudo ./tortunnel.sh --start eth0
```

Finally, stop tunneling traffic through Tor.

```
sudo ./tortunnel.sh --stop
```

If necessary, restart the Tor service. This will refresh (renew) all circuits.

```
sudo ./tortunnel.sh --refresh
```

## Auto-start

To auto-start TorTunnel on boot, edit the crontab of the root user:

```
sudo crontab -e
```

And add the following line:

```
@reboot cd /<PATH>/TorTunnel ; ./tortunnel.sh --start eth1
```

## Network Routing for LAN

This feature allows TorTunnel to accept inbound traffic on a given interface and serve them via Tor.

Change the default route and resolver on the clients (replace the IP accordingly):

```
sudo ip route add default via 192.168.1.1 dev enp1s0
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
echo 'nameserver 192.168.1.1' | sudo tee /etc/resolv.conf
```

Also, consider installing a DHCP service to automatically configure the client's network interfaces in the LAN interface.

## Why?

Disclosure: this project is a fork of https://github.com/neoslab/torbridge

My goal was to learn and understand how a system-wide configuration could route traffic through Tor by reverse engineering neoslab's torbridge script.

I changed the name because Tor Bridge has a different meaning inside the Tor universe and it created confusion.

Even though the original script worked, it created files that worked as flags. As soon as I rebooted without stopping the service, it stopped working because of the flags.

All kudos to neoslab. Not trying to do anything better. Just learning from them and making my version of it.
