# Third-Party Notices

This project uses, documents, or references software created by third parties. Each component remains subject to its own copyright and license — nothing in this repository replaces or supersedes those terms. This repository's own license (see `LICENSE`) covers only the original documentation, scripts, and examples written for this guide.

No source code from any project below is vendored or redistributed in this repository. This guide documents installation and configuration of software obtained directly from official Debian/Ubuntu package repositories — nothing here is a modified or repackaged copy.

---

## Dropbear SSH

**Project:** Dropbear SSH
**Author:** Matt Johnston
**Upstream repository:** https://github.com/mkj/dropbear
**Upstream homepage:** https://matt.ucc.asn.au/dropbear/dropbear.html
**License:** MIT-style license. See the upstream `LICENSE` file for the authoritative text — this notice does not restate license terms it hasn't directly verified against that file.
**Copyright:** See upstream source and `LICENSE` file.

Dropbear also incorporates code from other sources (e.g. cryptographic routines from LibTomCrypt/LibTomMath by Tom St Denis, and PTY-handling code derived from OpenSSH). Refer to the upstream `CREDITS`/source headers for full acknowledgements — not reproduced here to avoid an out-of-date secondhand copy.

This project does not vendor Dropbear's source. Where this guide references specific behavior, it is describing the version distributed via the Debian/Ubuntu package below.

## Ubuntu / Debian packaging (`dropbear`, `dropbear-bin`, `dropbear-initramfs`)

**Project:** Debian/Ubuntu's packaging of Dropbear for use in `initramfs-tools`
**Distinct from:** upstream Dropbear source (above) — the packaging maintainers wrap upstream Dropbear with Debian/Ubuntu-specific integration scripts (hooks that place Dropbear into the initramfs build), under their own separate packaging copyright.
**License:** See `/usr/share/doc/dropbear-initramfs/copyright` on an installed system, or the package's entry on https://packages.debian.org/search?keywords=dropbear-initramfs — not restated here since exact packaging copyright can change between releases.
**Versions referenced by this guide:** see the "Tested versions" table in `README.md`.

Key integration files this guide describes (installed by the package, not authored by this project):

```
/usr/share/initramfs-tools/conf-hooks.d/dropbear
/usr/share/initramfs-tools/hooks/dropbear
/usr/share/initramfs-tools/scripts/init-premount/dropbear
/usr/share/initramfs-tools/scripts/init-bottom/dropbear
```

## initramfs-tools

**Project:** initramfs-tools
**Origin:** Debian, packaged for Ubuntu
**License:** See `/usr/share/doc/initramfs-tools/copyright` on an installed system, or https://packages.debian.org/search?keywords=initramfs-tools

## cryptsetup / cryptsetup-initramfs

**Project:** cryptsetup (LUKS disk encryption tooling)
**License:** See `/usr/share/doc/cryptsetup/copyright` on an installed system, or https://packages.debian.org/search?keywords=cryptsetup

---

## A note on how this list is maintained

Licenses for dependencies are **not guessed**. If a license isn't clearly confirmed against the actual upstream source or the installed package's copyright file, this document says so explicitly rather than asserting a specific license text. If you're extending this repository and add a new dependency, check `/usr/share/doc/<package>/copyright` on your own system before writing an entry here.

## Attribution philosophy

This guide exists because excellent open-source software already exists — it is a walkthrough of *using* that software, not a claim of authorship over it. If anything in this repository ever reads as though Dropbear, cryptsetup, or initramfs-tools were created for or by this project, that's a documentation bug — please open an issue.
