# TorTunnel

This script tunnels all system traffic through Tor and was designed and tested on Ubuntu 24.04 LTS.

No more SOCKS configuration per application or `proxychains`. Even DNS is tunneled!

## Usage

```
Usage: tortunnel [--backup] [--install|--start] [--restore|--stop] [--refresh]

Options:
 --backup             backup the original system's configuration before installation
 --install, --start   make changes to the system's configuration and start tunneling
 --restore, --stop    restore backup with original system's configuration
 --refresh            request Tor to acquire a new connection
```

The first step is to back up the original configuration for later restoration.

```
sudo ./tortunnel.sh --backup
```

Then, start tunneling traffic through Tor.

```
sudo ./tortunnel.sh --start
```

Finally, stop tunneling traffic through Tor.

```
sudo ./tortunnel.sh --stop
```

Optionally, restart the Tor service if necessary. All circuits will be refreshed (new).

```
sudo ./tortunnel.sh --refresh
```

## Auto-start

To auto-start TorTunnel edit the crontab of the root user:

```
sudo crontab -e
```

And add the following line:

```
@reboot /<PATH>/tortunnel.sh --start
```

## Why?

Disclosure: this project is a fork of https://github.com/neoslab/torbridge

My goal was to learn and understand how a system-wide configuration could route traffic through Tor by reverse engineering neoslab's torbridge script.

I changed the name because Tor Bridge has a different meaning inside the Tor universe and it created confusion.

Even though the original script worked, it created files that worked as flags. As soon as I rebooted without stopping the service, it stopped working because of the flags.

All kudos to neoslab. Not trying to do anything better. Just learning from them and making my version of it.
