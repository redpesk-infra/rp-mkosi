#!/bin/bash

# Goal: copy bootloader image from BUILDROOT 
# to usable directory for %PostOutputScript

set -e

[ -z "$REDPESK_FLASH_BINS" ] &&
	echo "REDPESK_FLASH_BINS env variable not defined please provide it '-E REDPESK_FLASH_BINS='" >&2 &&
	exit 1

mkdir -p $UBOOT_DIR # defined in flash-uboot.conf

REDPESK_FLASH_PATH=$(echo "$REDPESK_FLASH_BINS" | cut -d':' -f1)

if ! cp -f "$BUILDROOT/$REDPESK_FLASH_PATH" "$UBOOT_DIR" ; then
    echo "Error: $BUILDROOT/$REDPESK_FLASH_PATH file not found in $BUILDROOT"
    exit 1
else
    echo "The bootloader has been copied successfully to $SRCDIR/$UBOOT_DIR"
fi
