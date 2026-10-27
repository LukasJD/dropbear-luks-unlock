# Changelog

All notable changes to this project are documented in this file.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
versions follow [Semantic Versioning](https://semver.org/).

## [1.0.0] - 2026-10-28

First stable release.

### Added

- Beginner-friendly guide: unlock a LUKS-encrypted headless server over SSH
  using Dropbear in initramfs (Debian 12+ / Ubuntu 23.04+).
- Ten-part documentation set: overview, prerequisites, installation,
  networking, SSH authentication, `cryptroot-unlock`, initramfs internals,
  boot flow, troubleshooting, and security hardening — plus a glossary.
- `VERIFY.md`: post-install verification checks (A1–A6), including the
  public-key fingerprint check via `dropbearkey -y | ssh-keygen -lf -`.
- Ready-to-run scripts in `scripts/` and worked examples in `examples/`.
- MIT license, contribution guidelines, code of conduct, and security policy.

[1.0.0]: https://github.com/LukasJD/dropbear-luks-unlock/releases/tag/v1.0
