# 10. Security

See also `SECURITY.md` at the repo root for the formal disclosure/reporting policy. This chapter goes into the reasoning behind it.

## Threat model this guide assumes

A trusted home LAN. Not the public internet, not a shared/untrusted network. If your situation differs, treat this as a different threat model and harden further before relying on it — see `SECURITY.md`'s checklist.

## Why the OS firewall doesn't help here

`ufw`/`iptables` rules are configured by, and live on, the encrypted root filesystem. During the initramfs stage that filesystem isn't mounted yet, so those rules simply aren't loaded or active. Dropbear's listening port is reachable to anything that can route to the machine on your LAN, independent of whatever firewall policy you've set for the fully-booted OS.

## Why key-only auth matters more here than usual

There's no fail2ban, no rate limiting, no account lockout at the initramfs stage — nothing analogous to what your real OS might have protecting normal SSH. The `-s` flag (disabling password auth entirely) and the `command=` restriction on the authorized key aren't optional hardening extras here; they're effectively your entire defense-in-depth stack at this layer.

## Physical access is a different threat model entirely

The initramfs image is unencrypted by necessity — the kernel must read it before any decryption can occur. Someone with physical access to the boot media could, in principle, tamper with it. This is true of *any* LUKS + initramfs setup, not something introduced by adding Dropbear. If physical security of the hardware itself is a concern, that requires separate mitigations (tamper-evident seals, secure boot chains, a locked enclosure) outside the scope of this guide.

## Key hygiene

- Use a **dedicated** unlock key, never your everyday login key
- Back the private key up somewhere off the server — losing it with no alternative unlock path leaves physical access as your only fallback
- If you ever suspect the key is compromised, remove its line from `authorized_keys`, rebuild the initramfs, and generate a fresh keypair

## What this setup does not protect against

- A compromised client machine (if your laptop is compromised, the attacker has your private key)
- Network-level attackers if you've exposed this beyond your LAN without additional protections (VPN, port restriction by source IP, etc.)
- Anyone with physical access to the server's boot media
