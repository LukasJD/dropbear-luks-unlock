# 7. Understanding initramfs

## What it actually is

The initramfs ("initial RAM filesystem") is a small, temporary filesystem the kernel loads entirely into RAM at boot, before your real root filesystem is available. On Debian/Ubuntu it's built by `initramfs-tools` and stored as a compressed cpio archive at `/boot/initrd.img-<kernel-version>`.

It contains just enough — a minimal busybox environment, kernel modules, and (in this setup) Dropbear — to get from "kernel just started" to "real root filesystem is mounted and ready."

## Why it has to be unencrypted

The kernel needs to be able to read the initramfs *before* any decryption can happen — LUKS unlocking is one of the things the initramfs itself is responsible for doing. This is inherent to how disk encryption bootstrapping works, not a weakness specific to this guide's setup. See `docs/10-security.md` for what this means practically.

## The build/rebuild command

```bash
sudo update-initramfs -u
```

This regenerates the image for the currently running kernel, incorporating whatever is currently configured in `/etc/dropbear/initramfs/`, `/etc/initramfs-tools/initramfs.conf`, and any installed hooks. It must be re-run after any relevant config change — nothing takes effect just by editing a file.

## Inspecting what's actually inside

```bash
lsinitramfs /boot/initrd.img-$(uname -r) | grep dropbear
```

Or use `scripts/inspect-initramfs.sh` in this repo for a fuller report.

## Config file locations relevant to this guide

```
/etc/initramfs-tools/initramfs.conf     ← static IP config (docs/04-networking.md)
/etc/dropbear/initramfs/dropbear.conf   ← Dropbear runtime options (docs/06-cryptroot-unlock.md)
/etc/dropbear/initramfs/authorized_keys ← who can connect (docs/05-ssh-authentication.md)
```
