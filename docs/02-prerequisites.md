# 2. Prerequisites

## Required

- [ ] A Debian- or Ubuntu-based server with a LUKS-encrypted root filesystem, already installed and bootable via normal keyboard/monitor unlock
- [ ] Root or sudo access on that server
- [ ] A second computer on the same LAN to connect from
- [ ] The server connected via Ethernet — Wi-Fi is generally not available this early in boot
- [ ] Router admin access, for the DHCP reservation step

## Assumed knowledge

This guide assumes you can already:

- Navigate a Linux terminal (`cd`, `ls`, running commands with `sudo`)
- Edit a file with a terminal text editor (examples use `nano`)
- Reboot a server and reconnect via SSH once it's back up

If any of that is shaky, that's fine — just expect those specific moments to take longer, not that the guide won't work for you.

## Not covered by this guide

- Setting up LUKS encryption itself — this guide assumes it already exists
- Non-Debian/Ubuntu distributions (Fedora, Arch, etc. use `dracut` instead — see the FAQ in `README.md`)
- Exposing this setup to the public internet — see `docs/10-security.md` before even considering it

## Before you start: gather this information

| Item | Where to find it | Example |
|---|---|---|
| Server's network interface name | `ip a` on the server | `eth0`, `enp3s0` |
| Server's MAC address | `ip link show <interface>` | `78:24:af:83:88:fd` |
| Router's admin address | Usually printed on the router, or `ip route` on the server for the gateway | `192.168.1.1` |
| Desired static IP | Must be outside your router's dynamic DHCP pool range | `192.168.1.50` |
