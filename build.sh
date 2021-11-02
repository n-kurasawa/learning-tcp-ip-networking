#!/usr/bin/env bash

set -e
set -o pipefail

function ns() {
  sudo ip netns add "${param[1]}"
}

function delnsall() {
  sudo ip -all netns delete
}

function veth() {
  sudo ip link add "${param[1]}" type veth peer name "${param[2]}"
}

function setveth() {
  sudo ip link set "${param[1]}" netns "${param[2]}"
}

function up() {
  sudo ip netns exec "${param[1]}" ip link set "${param[2]}" up
}

function ip() {
  sudo ip netns exec "${param[1]}" ip address add "${param[2]}" dev "${param[3]}"
}

function route() {
  sudo ip netns exec "${param[1]}" ip route add "${param[2]}" via "${param[3]}"
}

function forward() {
  sudo ip netns exec "${param[1]}" sysctl net.ipv4.ip_forward=1
}

function mac() {
  sudo ip netns exec "${param[1]}" ip link set dev "${param[2]}" address "${param[3]}"
}

function dump() {
  sudo ip netns exec "${param[1]}" tcpdump -tnel -i "${param[2]}" icmp or arp
}

function pin() {
  sudo ip netns exec "${param[1]}" ping -c 3 "${param[2]}"
}

function nefl() {
  sudo ip netns exec "${param[1]}" ip neigh flush all
}

function dnsmasq() {
  sudo ip netns exec server dnsmasq --dhcp-range=192.0.2.100,192.0.2.200,255.255.255.0 \
    --interface=s-veth0 \
    --port 0 \
    --no-resolv \
    --no-daemon
}

for OPT in "$@"; do
  param+=("$OPT")
done

case "${param[0]}" in
'ns')
    ns
    ;;
'delnsall')
    delnsall
    ;;
'veth')
    veth
    ;;
'setveth')
    setveth
    ;;
'up')
    up
    ;;
'ip')
    ip
    ;;
'mac')
    mac
    ;;
'dump')
    dump
    ;;
'pin')
    pin
    ;;
'nefl')
    nefl
    ;;
'route')
    route
    ;;
'forward')
    forward
    ;;
'dnsmasq')
    dnsmasq
    ;;
*)
    echo "[ERROR] $PROGNAME: illegal subcommand -- '$(echo ${param[0]})'"
    usage
    exit 1
    ;;
esac
