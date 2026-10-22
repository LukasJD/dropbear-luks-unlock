# 6. Runtime Options and the Unlock Process

## Configure Dropbear's runtime options

```bash
sudo nano /etc/dropbear/initramfs/dropbear.conf
```

```
DROPBEAR_OPTIONS="-p 2222 -s -j -k -I 60"
```

| Flag | Meaning |
|---|---|
| `-p 2222` | Listen on a non-default port |
| `-s` | Disable password logins entirely — key-only |
| `-j` / `-k` | Disable local/remote port forwarding at the binary level (redundant with the `authorized_keys` restriction — defense in depth) |
| `-I 60` | Idle timeout in seconds |

### Why a non-standard port matters

Your client's `~/.ssh/known_hosts` already has an entry for the server's IP on port 22 from normal post-boot SSH sessions. Since Dropbear presents a *different* host key (see `docs/05-ssh-authentication.md`), sharing port 22 would trigger a "REMOTE HOST IDENTIFICATION HAS CHANGED" warning on every single reboot — technically correct behavior from SSH's perspective, but alarming and easy to start ignoring. A distinct port keeps the two identities in separate `known_hosts` entries.

## Rebuild the initramfs

```bash
sudo update-initramfs -u
```

Any time you change a Dropbear or networking config file, this must be re-run or the change has no effect. It repacks the compressed image at `/boot/initrd.img-<kernel-version>` with the updated Dropbear binary, host keys, `authorized_keys`, and network config bundled in.

## Test it

```bash
sudo reboot
```

From the client, during the boot window (before the disk unlocks):

```bash
ssh -p 2222 -i ~/.ssh/myserver_unlock root@<server-ip>
```

Verify the presented host key fingerprint against the one recorded during install (`docs/03-installation.md`), then trust it.

## What a successful unlock looks like

```
Please unlock disk dm_crypt-0:
cryptsetup: dm_crypt-0 set up successfully
Connection to <server-ip> closed.
```

- **`Please unlock disk dm_crypt-0:`** — the forced command (`cryptroot-unlock`) ran automatically and is prompting for the passphrase
- **`cryptsetup: dm_crypt-0 set up successfully`** — the passphrase was correct, LUKS unlocked and mapped the volume
- **`Connection to ... closed`** — expected, not an error. The forced command finished its one job and the session ends; the server continues booting normally

## Confirm normal SSH still works separately

After the server finishes booting:

```bash
ssh <your-username>@<server-ip>
```

This should work exactly as it always has, on port 22 with your normal key — confirming the two SSH identities (Dropbear on 2222, your real OS's sshd on 22) run completely independently.
