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

function mac() {
  sudo ip netns exec "${param[1]}" ip link set dev "${param[2]}" address "${param[3]}"
}

function dump() {
  sudo ip netns exec "${param[1]}" tcpdump -tnel -i "${param[2]}" icmp
}

function pin() {
  sudo ip netns exec "${param[1]}" ping -c 3 "${param[2]}"
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
*)
    echo "[ERROR] $PROGNAME: illegal subcommand -- '$(echo ${param[0]})'"
    usage
    exit 1
    ;;
esac
