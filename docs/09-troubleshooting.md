# 9. Troubleshooting

| Symptom | Likely cause | Where to look |
|---|---|---|
| `WARNING: Invalid authorized_keys file` at install or boot | The file doesn't exist yet, or is empty/malformed | `docs/05-ssh-authentication.md` |
| SSH warns the host key changed, on every single reboot | Dropbear sharing a port with your regular SSH server | Set a distinct port, `docs/06-cryptroot-unlock.md` |
| Can't connect at all during the boot window | Static IP mismatch, or Ethernet not connected, or Wi-Fi being relied on (won't work this early) | `docs/04-networking.md` |
| Connects, but the forced unlock command doesn't run | Malformed `authorized_keys` line — check for smart-quote autocorrect or a stray space inside the comma-list | `docs/05-ssh-authentication.md` |
| `ip a` shows `dynamic` even after setting a static `IP=` line | That's expected — `ip a` reports **post-boot** networking (DHCP/NetworkManager), which is separate from the initramfs-stage static config | `docs/04-networking.md` |
| Config changes don't seem to take effect | Forgot to rebuild: `sudo update-initramfs -u` | `docs/07-initramfs.md` |
| Not sure if `dracut` or `initramfs-tools` is actually active | `dpkg -l \| grep -E 'dracut\|initramfs-tools'` and check `/etc/kernel/postinst.d/` for which hook is registered | `docs/03-installation.md` |
| Locked out entirely — no key works | Fall back to physical keyboard/monitor unlock, same as before this setup existed. This is why key backups matter. | `docs/10-security.md` |

## General debugging approach

1. **Confirm plain interactive LUKS unlock still works first** (keyboard/monitor). If that's broken, fix it before touching anything network-related — you don't want two unknowns at once.
2. **Check what's actually in the built initramfs** with `scripts/inspect-initramfs.sh` — config file changes that were never rebuilt are a common source of "I set this but it's not working."
3. **Verify versions match what this guide was tested against** — `scripts/check-system.sh` and the reproducibility table in `README.md`.
