#!/bin/bash

# Goal: copy bootloader image(s) from BUILDROOT 
# to usable directory for %PostOutputScript

set -e

if [ -z "$REDPESK_FLASH_BINS" ]; then
    echo "REDPESK_FLASH_BINS env variable not defined please provide it '-E REDPESK_FLASH_BINS='" >&2
    exit 1
fi

mkdir -p $UBOOT_DIR # defined in flash-uboot.conf

for boot_image in $REDPESK_FLASH_BINS; do
    REDPESK_FLASH_PATH=$(echo "$boot_image" | cut -d':' -f1)

    if ! cp -f "$BUILDROOT""$REDPESK_FLASH_PATH" "$UBOOT_DIR"; then
        echo "Error: $BUILDROOT""$REDPESK_FLASH_PATH file not found in $BUILDROOT"
        exit 1
    else
        echo "The boot image '$REDPESK_FLASH_PATH' has been successfully copied to $SRCDIR/$UBOOT_DIR"
    fi
done
