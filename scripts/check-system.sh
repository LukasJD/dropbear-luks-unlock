#!/usr/bin/env bash
# check-system.sh
# Reports the installed versions relevant to this guide, so you can compare
# against the "Tested versions" table in README.md. Read-only — makes no changes.

set -euo pipefail

echo "=== OS release ==="
if [ -f /etc/os-release ]; then
    grep -E '^(PRETTY_NAME|VERSION)=' /etc/os-release
else
    echo "  /etc/os-release not found"
fi

echo
echo "=== Kernel ==="
uname -r

echo
echo "=== Relevant package versions ==="
for pkg in dropbear-bin dropbear-initramfs initramfs-tools initramfs-tools-core \
           cryptsetup-initramfs dracut dracut-core dracut-network; do
    if dpkg -l "$pkg" >/dev/null 2>&1; then
        version=$(dpkg-query -W -f='${Version}' "$pkg" 2>/dev/null || echo "unknown")
        printf "  %-25s %s\n" "$pkg" "$version"
    fi
done

echo
echo "=== Active initramfs generator ==="
echo "Registered kernel postinst hooks (whichever appear here is what actually"
echo "runs on a kernel update — having both dracut and initramfs-tools hooks"
echo "present at once usually means a leftover from an incomplete migration):"
ls /etc/kernel/postinst.d/ 2>/dev/null || echo "  (directory not found)"

echo
echo "=== Dropbear config files present ==="
ls -la /etc/dropbear/initramfs/ 2>/dev/null || echo "  dropbear-initramfs not installed"

echo
echo "Compare this output against the 'Tested versions' table in README.md."
