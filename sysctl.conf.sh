#!/bin/bash
# TorTunnel
## Swappiness
sysctl -w vm.dirty_ratio=10
sysctl -w vm.dirty_background_ratio=5
sysctl -w vm.dirty_expire_centisecs=2000
sysctl -w vm.dirty_writeback_centisecs=1000
sysctl -w vm.swappiness=10
sysctl -w vm.vfs_cache_pressure=70
## Disable Explicit Congestion Notification in TCP
sysctl -w net.ipv4.tcp_ecn=0
## Window scaling
sysctl -w net.ipv4.tcp_window_scaling=1
## Increase Linux auto-tuning TCP buffer limits
sysctl -w net.ipv4.tcp_rmem="8192 87380 16777216"
sysctl -w net.ipv4.tcp_wmem="8192 65536 16777216"
## Increase TCP max buffer size
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216
## Increase number of incoming connections backlog
sysctl -w net.core.netdev_max_backlog=16384
sysctl -w net.core.dev_weight=64
## Increase number of incoming connections
sysctl -w net.core.somaxconn=32768
## Increase the maximum amount of option memory buffers
sysctl -w net.core.optmem_max=65535
## Increase the TCP-time-wait buckets
## Pool sizeto prevent simple DOS attacks
sysctl -w net.ipv4.tcp_max_tw_buckets=1440000
## Try to reuse time-wait connections
sysctl -w net.ipv4.tcp_tw_reuse=1
## Limit number of allowed orphans
## Each orphan can eat up to 16M of unswappable memory
sysctl -w net.ipv4.tcp_max_orphans=16384
sysctl -w net.ipv4.tcp_orphan_retries=0
## Don't cache ssthresh from previous connection
sysctl -w net.ipv4.tcp_no_metrics_save=1
sysctl -w net.ipv4.tcp_moderate_rcvbuf=1
## Increase size of RPC datagram queue length
sysctl -w net.unix.max_dgram_qlen=50
## Don't allow the ARP table to become bigger than this
sysctl -w net.ipv4.neigh.default.gc_thresh3=2048
## Tell the gc when to become aggressive with arp table cleaning
## Adjust this based on size of the LAN. 1024 is suitable for most /24 networks
sysctl -w net.ipv4.neigh.default.gc_thresh2=1024
## Adjust where the GC will leave ARP table alone set to 32
sysctl -w net.ipv4.neigh.default.gc_thresh1=32
## Adjust to ARP table GC to clean-up more often
sysctl -w net.ipv4.neigh.default.gc_interval=30
## Increase TCP queue length
sysctl -w net.ipv4.neigh.default.proxy_qlen=96
sysctl -w net.ipv4.neigh.default.unres_qlen=6
## Enable Explicit Congestion Notification
sysctl -w net.ipv4.tcp_ecn=1
sysctl -w net.ipv4.tcp_reordering=3
## How many times to retry killing an alive TCP connection
sysctl -w net.ipv4.tcp_retries2=15
sysctl -w net.ipv4.tcp_retries1=3
## Avoid falling back to slow start after a connection goes idle
## keeps our cwnd large with the keep alive connections (kernel > 3.6)
sysctl -w net.ipv4.tcp_slow_start_after_idle=0
## Allow the TCP fastopen flag to be used
## Beware some firewalls do not like TFO (kernel > 3.7)
sysctl -w net.ipv4.tcp_fastopen=3
## This will ensure that immediatly subsequent connections use the new values
sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv6.route.flush=1
## TCP SYN cookie protection
sysctl -w net.ipv4.tcp_syncookies=1
## TCP RFC 1337
sysctl -w net.ipv4.tcp_rfc1337=1
## Reverse path filtering
sysctl -w net.ipv4.conf.default.rp_filter=1
sysctl -w net.ipv4.conf.all.rp_filter=1
## Log martian packets
sysctl -w net.ipv4.conf.default.log_martians=1
sysctl -w net.ipv4.conf.all.log_martians=1
## Disable ICMP redirecting
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0
sysctl -w net.ipv6.conf.all.accept_redirects=0
sysctl -w net.ipv6.conf.default.accept_redirects=0
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0
## Enable Ignoring to ICMP Request
sysctl -w net.ipv4.icmp_echo_ignore_all=1
## Disable IPv6
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
