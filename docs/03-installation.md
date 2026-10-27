# 3. Installation

## Install the package

```bash
sudo apt update
sudo apt install dropbear-initramfs
```

> **Path note:** on **Debian 12+ and recent Ubuntu (roughly 23.04+)** everything lives under `/etc/dropbear/initramfs/`. Older releases use `/etc/dropbear-initramfs/` — same files, same names. If only the older directory exists on your system, use it wherever this guide says `/etc/dropbear/initramfs/`.

This single package pulls in everything needed:

| Package | Role |
|---|---|
| `dropbear-bin` | The Dropbear SSH server binary itself |
| `dropbear-initramfs` | Debian/Ubuntu's integration scripts that place Dropbear into the initramfs build |
| `initramfs-tools` | The generator that actually builds the initramfs image (installed as a dependency if not already present) |
| `cryptsetup-initramfs` | Provides `cryptroot-unlock` and the LUKS-handling hooks inside initramfs |

## What happens during install

1. **Host keys are generated** (RSA, ECDSA, ED25519) and saved to `/etc/dropbear/initramfs/` as `dropbear_rsa_host_key`, `dropbear_ecdsa_host_key` and `dropbear_ed25519_host_key`. Dropbear stores each key as a **single file in its own format — there are no separate `.pub` files** (unlike your `ssh-keygen`-generated client key). Their fingerprints print to the console during install — **record these now**, you'll need them to verify you're not facing a real man-in-the-middle later. (To see a fingerprint again later, use `dropbearkey -y -f <keyfile> | ssh-keygen -lf -` — plain `ssh-keygen -lf <keyfile>` cannot read Dropbear's format.)
2. **You'll see a warning:**
   ```
   dropbear: WARNING: Invalid authorized_keys file, SSH login to initramfs won't work!
   ```
   This is expected — no client key has been authorized yet. That's the next chapter.
3. **The initramfs is rebuilt automatically** as a post-install trigger, though it won't do anything useful yet without the remaining configuration steps.

## If you're switching from `dracut`

Some systems (unusually, for Ubuntu) may have `dracut` installed instead of `initramfs-tools`. Installing `dropbear-initramfs` will prompt to remove `dracut`, since only one initramfs generator can be active. Confirming that removal is the expected path for this guide. See `README.md`'s FAQ for the `dracut`-native alternative if you'd rather keep `dracut`.

## Verify the install

```bash
dpkg -l | grep -E 'dropbear|initramfs-tools|cryptsetup-initramfs'
ls /etc/dropbear/initramfs/
```

You should see host key files and a `dropbear.conf`, but no `authorized_keys` yet — that file doesn't exist until you create it in the next chapter.
