# Security

## This is not secure by default

Following this guide gives you remote LUKS unlock — it does **not**, on its own, make that unlock mechanism hardened for every threat model. Read this before deploying it anywhere beyond a trusted home LAN.

## Known limitations (by design, not bugs)

- **No OS firewall protection.** `ufw`/`iptables` rules live on the encrypted disk and are not active during the initramfs stage. The Dropbear port is reachable to anything that can route to the machine, regardless of your normal firewall configuration.
- **No brute-force protection at the initramfs stage.** No fail2ban, no rate limiting. Key-only authentication is the entire defense at this layer.
- **The initramfs image itself is unencrypted.** This is inherent to how LUKS + initramfs works everywhere — the kernel must be able to read the initramfs before any decryption can happen. Physical access to the boot media defeats this regardless of any configuration here.
- **Host key trust on first connect is manual.** There is no certificate authority behind Dropbear's host keys in this setup — you are expected to manually verify the fingerprint shown at first connection against the one recorded during installation.

## Recommended minimum hardening

If you're following this guide, at minimum:

- [ ] Use a **dedicated** SSH keypair for unlock only — never reuse your everyday login key
- [ ] Restrict that key in `authorized_keys` with `command="/bin/cryptroot-unlock",no-port-forwarding,no-agent-forwarding,no-x11-forwarding`
- [ ] Disable password authentication (`-s` in `DROPBEAR_OPTIONS`)
- [ ] Use a non-default port to avoid host-key confusion with your regular SSH server
- [ ] Keep the unlock private key backed up somewhere off the server itself

## Threat models this guide assumes

This guide is written for a **trusted home LAN**. If any of the following apply to your situation, treat this as a different, higher-stakes threat model and harden further before relying on it:

- The server is port-forwarded or otherwise reachable from the public internet
- The LAN is shared with untrusted devices or users
- The server holds data subject to a compliance requirement (HIPAA, PCI-DSS, etc.)

## Reporting a security issue with this guide

If you find a mistake in this guide that could lead someone into an insecure configuration (not a vulnerability in Dropbear/cryptsetup/initramfs-tools themselves — report those to their respective upstream projects), please open an issue describing the problem clearly. This is documentation, not a running service, so there's no embargo/disclosure timeline needed — public issues are fine.

## Reporting a vulnerability in the underlying software

This repository does not maintain Dropbear, cryptsetup, or initramfs-tools. Vulnerabilities in those projects should be reported upstream:

- Dropbear: see https://github.com/mkj/dropbear
- Debian/Ubuntu packaging issues: https://bugs.launchpad.net/ubuntu (Ubuntu) or https://bugs.debian.org (Debian)
