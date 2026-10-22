# 4. Networking

Two separate networking configurations matter here — don't conflate them.

## 4.1 — Router-level DHCP reservation (post-boot networking)

This tells your router "always hand this MAC address the same IP." It governs the server's address **after** the full OS has booted and its normal network manager requests an address via DHCP.

1. Find the server's MAC address:
   ```bash
   ip link show <interface>
   ```
2. In your router's admin page, find **DHCP Reservation** / **Static Lease** / **Address Reservation** (naming varies by router brand — Fritz!Box, Sagemcom, and others all phrase this differently).
3. Bind the MAC address to a fixed IP, outside the router's dynamic pool range.

This step alone does **not** configure networking during the initramfs stage — that's a separate, earlier point in boot where the OS's DHCP client isn't running yet.

## 4.2 — initramfs-stage static IP (pre-boot networking)

This is what actually lets Dropbear be reachable before the disk is unlocked:

```bash
sudo nano /etc/initramfs-tools/initramfs.conf
```

```
IP=<server-ip>::<gateway-ip>:<netmask>::<interface>:off
```

Format, piece by piece: `client-ip :: gateway : netmask : hostname : interface : autoconf`

Example:
```
IP=192.168.1.50::192.168.1.1:255.255.255.0::eth0:off
```

**Check for an existing `IP=` line first** rather than blindly adding a new one:

```bash
grep IP= /etc/initramfs-tools/initramfs.conf
```

- Nothing returned → add the line (anywhere in the file — it's parsed as `KEY=VALUE` pairs, not read top-to-bottom)
- A commented-out line (`#IP=...`) → edit that line, removing the `#`
- An active line already present → edit it in place rather than adding a duplicate

## Why both are needed

The router reservation keeps the address stable long-term and covers the DHCP-based fallback some initramfs configurations use. The static `IP=` line guarantees the address is available specifically during the brief early-boot window, without depending on the router responding to a DHCP request in time — which matters more here, since a failed network bring-up at that stage means no remote unlock is possible at all.
