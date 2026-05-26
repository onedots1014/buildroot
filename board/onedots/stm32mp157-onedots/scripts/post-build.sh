#!/bin/bash
# Buildroot ROOTFS_POST_BUILD_SCRIPT hook.
#
# Buildroot calls this with $TARGET_DIR as the first positional argument
# (the staging rootfs tree). Buildroot also exports BR2_* and a few other
# variables (BUILD_DIR, etc.). We rely on the caller (top-level build.sh)
# to additionally export:
#
#   OUTPUT_DIR   — the SDK's per-board output dir, e.g. output/onedots_stm32mp157
#
# Responsibilities:
#   1. Copy Cortex-M4 firmware ELFs from $OUTPUT_DIR/m4 → /lib/firmware
#   2. Copy kernel modules from $OUTPUT_DIR/modules_install → /lib/modules
#
# Both copies are best-effort: if the BSP path has not been built yet, the
# rootfs is still produced (just without those bits). The caller is expected
# to do `./build.sh kernel` and `./build.sh m4` before `./build.sh rootfs-br`.

set -euo pipefail

TARGET_DIR="${1:?Buildroot must pass TARGET_DIR as first argument}"
: "${OUTPUT_DIR:?post-build.sh requires OUTPUT_DIR to be exported by the caller}"

log() { echo "[post-build] $*"; }

# ----------------------------------------------------------------------------
# Inject M4 firmware
# ----------------------------------------------------------------------------
m4_src="$OUTPUT_DIR/m4"
if [[ -d "$m4_src" ]] && compgen -G "$m4_src/*.elf" >/dev/null; then
    mkdir -p "$TARGET_DIR/lib/firmware"
    cp -v "$m4_src"/*.elf "$TARGET_DIR/lib/firmware/"
    chmod 644 "$TARGET_DIR/lib/firmware/"*.elf
    log "Injected M4 firmware from $m4_src"
else
    log "No M4 firmware at $m4_src — skipping (run './build.sh m4' first to include it)"
fi

# ----------------------------------------------------------------------------
# Inject kernel modules
# Kernel build script writes to $OUTPUT_DIR/modules_install via INSTALL_MOD_PATH,
# producing $OUTPUT_DIR/modules_install/lib/modules/<kver>/...
# ----------------------------------------------------------------------------
modules_src="$OUTPUT_DIR/modules_install/lib/modules"
if [[ -d "$modules_src" ]]; then
    mkdir -p "$TARGET_DIR/lib/modules"
    cp -a "$modules_src/." "$TARGET_DIR/lib/modules/"
    log "Injected kernel modules from $modules_src"
else
    log "No kernel modules at $modules_src — skipping (run './build.sh kernel' first)"
fi

log "Done."
