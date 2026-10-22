#!/usr/bin/env bash
# inspect-initramfs.sh
# Lists what's actually inside the currently-built initramfs image, so you can
# confirm a config change actually took effect after rebuilding. Read-only.

set -euo pipefail

KERNEL_VERSION="$(uname -r)"
IMAGE="/boot/initrd.img-${KERNEL_VERSION}"

if [ ! -f "$IMAGE" ]; then
    echo "Could not find $IMAGE — pass a path explicitly:"
    echo "  $0 /boot/initrd.img-<version>"
    exit 1
fi

if ! command -v lsinitramfs >/dev/null 2>&1; then
    echo "lsinitramfs not found — it ships with initramfs-tools. Install that first."
    exit 1
fi

echo "=== Inspecting: $IMAGE ==="

echo
echo "--- Dropbear-related files ---"
lsinitramfs "$IMAGE" | grep -i dropbear || echo "  (none found — dropbear-initramfs may not be installed/built in)"

echo
echo "--- cryptsetup-related files ---"
lsinitramfs "$IMAGE" | grep -i crypt || echo "  (none found)"

echo
echo "--- Network config baked in (conf/initramfs.conf's IP= only affects the"
echo "    live config used at boot, not necessarily what's listed here) ---"
lsinitramfs "$IMAGE" | grep -E 'net|ip' || echo "  (nothing obviously networking-related found)"

echo
echo "Tip: if a config change doesn't show up as expected above, you likely"
echo "forgot to run: sudo update-initramfs -u"
