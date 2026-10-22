# Glossary

Plain-English definitions for terms used throughout this guide. If a word confused you somewhere, it's probably here.

**authorized_keys**
A file listing which public keys are allowed to log in. Dropbear's version, at `/etc/dropbear/initramfs/authorized_keys`, is completely separate from any regular user's `~/.ssh/authorized_keys`.

**cryptroot-unlock**
The specific command that prompts for a LUKS passphrase and unlocks the encrypted volume, from inside the initramfs environment. Provided by the `cryptsetup-initramfs` package.

**cryptsetup**
The underlying tool that manages LUKS-encrypted volumes — creating them, unlocking them, mapping them to a usable device.

**Dropbear**
A lightweight, minimal SSH server, created by Matt Johnston, small enough to fit inside a constrained environment like initramfs. Not the same program as your regular OpenSSH server.

**Fingerprint (host key fingerprint)**
A short hash representing a public key, used as a human-checkable way to verify a server's identity without comparing the entire (much longer) key.

**Host key**
A keypair that identifies a *server* to connecting clients. Different from an authorized/client key, which identifies a *client* to the server.

**initramfs**
"Initial RAM filesystem" — a small, temporary filesystem loaded entirely into RAM by the kernel at boot, used to do just enough setup (like unlocking an encrypted disk) to reach the real root filesystem.

**initramfs-tools**
The Debian/Ubuntu program that builds the initramfs image. (Other distros, like Fedora and Arch, use a different tool called `dracut` instead.)

**LUKS**
"Linux Unified Key Setup" — the standard disk encryption format used on Linux. What actually encrypts your disk; Dropbear and cryptsetup are tools used to unlock it remotely, not the encryption itself.

**MAC address**
A unique hardware identifier for a network interface, used by routers to recognize a specific device regardless of what IP address it currently has.

**Private key / Public key**
A matched pair where the private key proves an identity (and must never be shared) and the public key lets others verify that proof (and is safe to share/distribute). Rule of thumb: *private stays home, public travels.*

**Static IP**
A fixed, manually-assigned IP address, as opposed to one automatically handed out by DHCP each time. Needed here because DHCP isn't running yet at the initramfs stage.
