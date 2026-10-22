# 1. Overview

## The problem

A LUKS-encrypted root filesystem can't be mounted until someone provides the passphrase. Normally that means a keyboard and monitor physically attached to the machine at every boot — a dealbreaker for a headless homelab server tucked away somewhere inconvenient.

## The solution, in one sentence

Run a second, minimal SSH server (**Dropbear**) inside the temporary pre-boot environment (**initramfs**) so you can supply the passphrase remotely, before the real OS and its normal SSH server have even started.

## What Dropbear does in this setup

- Listens for an SSH connection during the initramfs stage only
- Authenticates you via a dedicated public key (not a password)
- Runs exactly one command when you connect — `cryptroot-unlock` — nothing else
- Exits automatically once that command finishes

## What Dropbear does NOT do here

- It is **not** your regular SSH server — your normal `openssh-server` on port 22 (or whatever you've configured) is completely separate and keeps working exactly as before, after boot
- It does **not** provide a general-purpose shell — the hardening in `docs/05-ssh-authentication.md` deliberately restricts it to one function
- It does **not** protect against physical access to the machine — see `docs/10-security.md`

## Relationship to the rest of this repo

`README.md` is the fastest path start-to-finish. These `docs/` chapters go deeper into each piece for anyone who wants the full "why," or who's troubleshooting something specific. Read `docs/glossary.md` first if any term here is unfamiliar.
