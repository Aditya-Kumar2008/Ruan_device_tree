#!/bin/bash
# Fix LTO in kernel .config - GKI kernels require ThinLTO
# This script patches the .config AFTER the merge_config step
# because olddefconfig always resets the choice to LTO_NONE

KOBJ="$1"
if [ -z "$KOBJ" ]; then
    echo "Usage: $0 <path-to-KERNEL_OBJ>"
    exit 1
fi

CONFIG="$KOBJ/.config"
ACONF="$KOBJ/include/config/auto.conf"
ACONFH="$KOBJ/include/generated/autoconf.h"

if [ ! -f "$CONFIG" ]; then
    echo "Error: $CONFIG not found"
    exit 1
fi

# Check if LTO is already correct
if grep -q "CONFIG_LTO_CLANG_THIN=y" "$CONFIG" && ! grep -q "CONFIG_LTO_NONE=y" "$CONFIG"; then
    echo "LTO already set correctly (ThinLTO)"
    exit 0
fi

echo "Fixing LTO in kernel config..."

# Fix .config
sed -i 's/CONFIG_LTO_NONE=y/# CONFIG_LTO_NONE is not set/' "$CONFIG"

# Add LTO lines if they don't exist
grep -q 'CONFIG_LTO=y' "$CONFIG" || sed -i '/# CONFIG_LTO_NONE is not set/a CONFIG_LTO=y' "$CONFIG"
grep -q 'CONFIG_LTO_CLANG=y' "$CONFIG" || sed -i '/CONFIG_LTO=y/a CONFIG_LTO_CLANG=y' "$CONFIG"
grep -q 'CONFIG_LTO_CLANG_THIN=y' "$CONFIG" || sed -i '/CONFIG_LTO_CLANG=y/a CONFIG_LTO_CLANG_THIN=y' "$CONFIG"
grep -q 'CONFIG_THINLTO=y' "$CONFIG" || sed -i '/CONFIG_LTO_CLANG_THIN=y/a CONFIG_THINLTO=y' "$CONFIG"
grep -q 'CONFIG_CFI_CLANG=y' "$CONFIG" || sed -i '/CONFIG_THINLTO=y/a CONFIG_CFI_CLANG=y' "$CONFIG"

# Fix auto.conf
if [ -f "$ACONF" ]; then
    sed -i 's/CONFIG_LTO_NONE=y/# CONFIG_LTO_NONE is not set/' "$ACONF"
    grep -q 'CONFIG_LTO=y' "$ACONF" || echo 'CONFIG_LTO=y' >> "$ACONF"
    grep -q 'CONFIG_LTO_CLANG=y' "$ACONF" || echo 'CONFIG_LTO_CLANG=y' >> "$ACONF"
    grep -q 'CONFIG_LTO_CLANG_THIN=y' "$ACONF" || echo 'CONFIG_LTO_CLANG_THIN=y' >> "$ACONF"
    grep -q 'CONFIG_THINLTO=y' "$ACONF" || echo 'CONFIG_THINLTO=y' >> "$ACONF"
    grep -q 'CONFIG_CFI_CLANG=y' "$ACONF" || echo 'CONFIG_CFI_CLANG=y' >> "$ACONF"
fi

# Fix autoconf.h
if [ -f "$ACONFH" ]; then
    sed -i 's/#define CONFIG_LTO_NONE 1/\/\* #undef CONFIG_LTO_NONE \*\//' "$ACONFH"
    grep -q '#define CONFIG_LTO 1' "$ACONFH" || echo '#define CONFIG_LTO 1' >> "$ACONFH"
    grep -q '#define CONFIG_LTO_CLANG 1' "$ACONFH" || echo '#define CONFIG_LTO_CLANG 1' >> "$ACONFH"
    grep -q '#define CONFIG_LTO_CLANG_THIN 1' "$ACONFH" || echo '#define CONFIG_LTO_CLANG_THIN 1' >> "$ACONFH"
    grep -q '#define CONFIG_THINLTO 1' "$ACONFH" || echo '#define CONFIG_THINLTO 1' >> "$ACONFH"
    grep -q '#define CONFIG_CFI_CLANG 1' "$ACONFH" || echo '#define CONFIG_CFI_CLANG 1' >> "$ACONFH"
fi

echo "LTO fixed: ThinLTO enabled, LTO_NONE disabled"
