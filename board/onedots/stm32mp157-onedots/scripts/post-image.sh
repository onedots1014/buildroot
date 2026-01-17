#!/bin/bash
set -e

BOARD_DIR="$(dirname "$0")"
OVERLAY_BOOT_DIR="$BOARD_DIR/../overlay/boot"
OVERLAY_TFA_FILE="$BOARD_DIR/../overlay/tf-a-onedots_stm32mp157c-512d-v1-serialboot.stm32"
: "${BINARIES_DIR:=output/images}"

# 创建 BINARIES_DIR
mkdir -p "$BINARIES_DIR"

# 复制 boot overlay
cp -rv "$OVERLAY_BOOT_DIR"/* "$BINARIES_DIR/"
cp -rv "$OVERLAY_TFA_FILE" "$BINARIES_DIR/"

# 调用官方 genimage.sh
support/scripts/genimage.sh -c "$BOARD_DIR/genimage-tfa.cfg"

