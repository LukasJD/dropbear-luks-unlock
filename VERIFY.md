# VERIFY.md — Confirm the setup actually works

Run this after every config change, and once before publishing this guide.
Read-only on the server; the only reboot is the final live test.

## A. Server-side checks (over your normal SSH session, while the OS is up)

```bash
# A1. Packages installed and versions recorded
dpkg -l | grep -E 'dropbear|initramfs-tools|cryptsetup-initramfs'
```
Expected: `dropbear-bin`, `dropbear-initramfs`, `initramfs-tools`, `cryptsetup-initramfs` all present as `ii`.

```bash
# A2. Dropbear runtime options contain the port
cat /etc/dropbear/initramfs/dropbear.conf
```
Expected: `DROPBEAR_OPTIONS="-p 2222 -s -j -k -I 60"` (or your chosen values).
**This is the line most people miss.** If `-p 2222` is missing here, the server
listens on 22 at boot and your unlock command with `-p 2222` fails.

```bash
# A3. Authorized key exists, is restricted, is one line
sudo cat /etc/dropbear/initramfs/authorized_keys
wc -l /etc/dropbear/initramfs/authorized_keys
```
Expected: exactly 1 line, starting with restrictions, containing
`command="/bin/cryptroot-unlock"` (this path is verified correct: the
`cryptsetup-initramfs` hook copies the script to `/bin/cryptroot-unlock`
inside the initramfs — checked against Debian package `2:2.7.5-2`).

```bash
# A4. Static initramfs IP line matches the router reservation
grep -E '^\s*IP=' /etc/initramfs-tools/initramfs.conf
```
Expected: `IP=<your-ip>::<gateway>:255.255.255.0::<interface>:off`

```bash
# A5. Unlock tooling is actually baked into the current initramfs image
sudo lsinitramfs /boot/initrd.img-$(uname -r) | grep -E 'cryptroot-unlock|dropbear'
```
Expected: `/bin/cryptroot-unlock` present, plus `bin/dropbear` and
`etc/dropbear/initramfs/authorized_keys`. If absent → rebuild with
`sudo update-initramfs -u` and re-check.

```bash
# A6. Dropbear host keys exist and fingerprint matches what you recorded
ls /etc/dropbear/initramfs/ | grep dropbear
ssh-keygen -lf /etc/dropbear/initramfs/dropbear_rsa_host_key
```

## B. Client-side checks (PowerShell, before rebooting)

```powershell
# B1. Key exists where you think it does
Test-Path $env:USERPROFILE\.ssh\myserver_unlock

# B2. Confirm your .ssh config is not overriding the port for this host
Get-Content $env:USERPROFILE\.ssh\config -ErrorAction SilentlyContinue
```

## C. The live test (the only part that needs a reboot)

1. `sudo reboot` on the server, then wait ~15–30 s.
2. From PowerShell:
   ```powershell
   ssh -p 2222 -i $env:USERPROFILE\.ssh\myserver_unlock root@<server-ip>
   ```
   Expected: a forced `cryptroot-unlock` prompt, NOT a shell prompt.
   With `-I 60` set, you have 60 seconds to start typing.
3. Enter the LUKS passphrase. Expected: the SSH session closes itself
   as the boot continues — this is normal, not an error.
4. After the server is fully up, confirm normal SSH still works on port 22
   with your regular user and key:
   ```powershell
   ssh <your-user>@<server-ip>
   ```

If all four steps in section C pass, the setup is verified end-to-end.
