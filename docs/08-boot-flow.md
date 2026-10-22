# 8. Full Boot Flow

A stage-by-stage walkthrough of what happens on a reboot with this setup in place.

```
1. Power on / firmware (BIOS/UEFI)
        │
2. Bootloader (GRUB) loads the kernel and the initramfs image into RAM
        │
3. Kernel starts, hands control to the initramfs
        │
4. initramfs brings up networking using the static IP
   config from /etc/initramfs-tools/initramfs.conf
        │
5. Dropbear starts inside the initramfs, listening on
   the configured port (e.g. 2222), using its own
   independent host keys
        │
6. ── You connect here ──
   ssh -p 2222 -i ~/.ssh/myserver_unlock root@<server-ip>
        │
7. Your key matches the restricted entry in authorized_keys,
   which forces exactly one command: cryptroot-unlock
        │
8. cryptroot-unlock prompts for the LUKS passphrase over
   the SSH session
        │
9. Passphrase is correct → cryptsetup unlocks and maps
   the encrypted volume → Dropbear's forced command
   finishes → SSH session closes automatically
        │
10. initramfs mounts the now-unlocked real root filesystem
        │
11. Control hands off from initramfs to the real OS
        │
12. systemd (or your init system) starts normally,
    including the REAL OpenSSH server — a completely
    separate service from Dropbear, on its own port (e.g. 22)
        │
13. Server is fully booted and reachable via your normal
    SSH login, exactly as before this setup existed
```

## The key insight this diagram makes visible

Steps 5–9 (Dropbear's entire lifecycle) happen **before** step 12 (your real SSH server even exists as a running process). They never overlap, never share keys, and never share a port if you've followed the hardening in `docs/06-cryptroot-unlock.md`. Troubleshooting tip: if you're ever confused about "which SSH am I even talking to," this diagram answers it — anything before step 10 is Dropbear, anything from step 12 onward is your normal sshd.
