#!/bin/bash
set -euo pipefail

NET_DEVICE=`ip route show default | awk '{print $5}'`

# Override MAC address to match the one found in the license.dat
MAC_ADDRESS=$(awk '{for (i=1;i<=NF;i++) if($i ~/^HOSTID=/) {print $i; exit}}' work/license.dat | cut -d= -f2 | sed -e 's/\r$//' -e 's/..\B/&:/g')

docker run -d --rm -e DISPLAY="${DISPLAY}" \
  --mac-address="${MAC_ADDRESS}" \
  --privileged --ipc host \
  -v docker-fpga-${USER}:"${HOME}" \
  -v /etc/machine-id:/etc/machine-id \
  -v /dev/bus/usb/:/dev/bus/usb/ \
  -v /tmp/.X11-unix/:/tmp/.X11-unix \
  -v "${HOME}":"${HOME}"/home \
  -e MOZ_NO_REMOTE=1 \
  -u "${USER}" \
  -w "${HOME}" \
  diamond:"${USER}" \
  /bin/bash -c /opt/docker-fpga/run.sh
