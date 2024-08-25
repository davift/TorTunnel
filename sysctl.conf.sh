#!/bin/bash
# TorTunnel

## Optimized memory/swapping/caching management.
sysctl -w vm.dirty_ratio=10
sysctl -w vm.dirty_background_ratio=5
sysctl -w vm.dirty_expire_centisecs=2000
sysctl -w vm.dirty_writeback_centisecs=1000
sysctl -w vm.swappiness=10
sysctl -w vm.vfs_cache_pressure=70

## Broadly increasing the max size of buffers, queues, and memory for networking.
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216
sysctl -w net.core.netdev_max_backlog=16384
sysctl -w net.core.dev_weight=64
sysctl -w net.core.somaxconn=32768
sysctl -w net.core.optmem_max=65535

## Custom parameters on ARP and GC for networking neighbor discovery.
sysctl -w net.ipv4.neigh.default.gc_thresh3=2048
sysctl -w net.ipv4.neigh.default.gc_thresh2=1024
sysctl -w net.ipv4.neigh.default.gc_thresh1=32
sysctl -w net.ipv4.neigh.default.gc_interval=30
sysctl -w net.ipv4.neigh.default.proxy_qlen=96
sysctl -w net.ipv4.neigh.default.unres_qlen=6

## Change Linux auto-tuning TCP buffer limits to controls how much data can be buffered by the TCP stack.
sysctl -w net.ipv4.tcp_rmem="8192 87380 16777216"
sysctl -w net.ipv4.tcp_wmem="8192 65536 16777216"

## Set orphan unswappable memory value and disable retries.
sysctl -w net.ipv4.tcp_max_orphans=16384
sysctl -w net.ipv4.tcp_orphan_retries=0

## Disable savinf metrics and use larger buffer size for TCP.
sysctl -w net.ipv4.tcp_no_metrics_save=1
sysctl -w net.ipv4.tcp_moderate_rcvbuf=1
sysctl -w net.ipv4.tcp_window_scaling=1

## Allow the TCP fastopen and disable slow start after an idle period.
sysctl -w net.ipv4.tcp_fastopen=3
sysctl -w net.ipv4.tcp_slow_start_after_idle=0

## Protects against TCP SYN flood
sysctl -w net.ipv4.tcp_syncookies=1

## Optimize reusing time-wait connections.
sysctl -w net.ipv4.tcp_tw_reuse=1
sysctl -w net.ipv4.tcp_rfc1337=1
sysctl -w net.ipv4.tcp_max_tw_buckets=1440000

## Enable ECN and reverse path filtering.
sysctl -w net.ipv4.conf.default.rp_filter=1
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.tcp_ecn=1

## Log Martian packets (that have invalid source address).
sysctl -w net.ipv4.conf.default.log_martians=1
sysctl -w net.ipv4.conf.all.log_martians=1

## Disable ICMP (ping)
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0
sysctl -w net.ipv4.icmp_echo_ignore_all=1
sysctl -w net.ipv4.route.flush=1

# Totaly disabling IPv6 to avoid leaking.
sysctl -w net.ipv6.conf.all.accept_redirects=0
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.accept_redirects=0
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w net.ipv6.route.flush=1

# Not clean why set the UNIX domain socket queue length to about 10%.
sysctl -w net.unix.max_dgram_qlen=50
