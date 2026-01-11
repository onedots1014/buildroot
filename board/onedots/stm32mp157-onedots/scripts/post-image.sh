# #!/bin/bash
# set -e

# BOARD_DIR="$(dirname $0)"
# OVERLAY_BOOT_DIR="$BOARD_DIR/../overlay/boot"

# # Create BINARIES_DIR if it doesn't exist
# if [ ! -d "${BINARIES_DIR}" ]; then
#     echo "Creating BINARIES_DIR at ${BINARIES_DIR}"
#     mkdir -p "${BINARIES_DIR}"
# fi

# if [ ! -d "$OVERLAY_BOOT_DIR" ]; then
#     echo "Error: Overlay boot directory not found at $OVERLAY_BOOT_DIR"
#     exit 1
# fi

# echo "Copying overlay boot files to ${BINARIES_DIR}"
# cp -rv "$OVERLAY_BOOT_DIR"/* "${BINARIES_DIR}/"

# exit $?


#!/bin/bash
set -e

BOARD_DIR="$(dirname "$0")"
OVERLAY_BOOT_DIR="$BOARD_DIR/../overlay/boot"
: "${BINARIES_DIR:=output/images}"

# 创建 BINARIES_DIR
mkdir -p "$BINARIES_DIR"

# 复制 boot overlay
cp -rv "$OVERLAY_BOOT_DIR"/* "$BINARIES_DIR/"

# 调用官方 genimage.sh
support/scripts/genimage.sh -c "$BOARD_DIR/genimage-tfa.cfg"

