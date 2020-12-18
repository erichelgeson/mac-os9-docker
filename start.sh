#!/usr/bin/env bash

set -e
set -x

OS9_MEM=${OS9_MEM:-512}
OS9_DISK=${OS9_DISK:-"MacOS9.2.img"}
if [ -n "${OS9_CDROM}" ]; then
  OS9_CDROM="-drive file=/drives/${OS9_CDROM},format=raw,media=cdrom"
fi
OS9_CDROM_BOOT=${OS9_CDROM_BOOT:-"c"}
# Port range for passive FTP - may be different based on your FTP Server.
# Tested with Rumpus 2 Pro
PORT_START=${PORT_START:-3000}
PORT_END=${PORT_END:-3009}
PORT_RANGE=$(for port in $(seq "$PORT_START" "$PORT_END"); do echo -n "hostfwd=tcp::$port-:$port,"; done)

env

qemu-system-ppc \
  -L pc-bios \
  -boot "${OS9_CDROM_BOOT}" \
  -M mac99,via=pmu \
  -m "${OS9_MEM}" \
  -drive file=/drives/"${OS9_DISK}",format=raw,media=disk \
  ${OS9_CDROM} \
  -prom-env 'auto-boot?=true' -prom-env 'boot-args=-v' -prom-env 'vga-ndrv?=true' \
  -display vnc=0.0.0.0:0 -device VGA,edid=on -nographic \
  -device sungem,netdev=network01 \
  -netdev user,id=network01,hostfwd=tcp::548-:548,hostfwd=tcp::21-:21,"${PORT_RANGE}"
