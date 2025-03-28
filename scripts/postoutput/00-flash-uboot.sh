#!/bin/bash

# Goal: flash bootloader to the final image 
# (U-Boot + firmwares + ARM Trusted Firmware)

# REDPESK_FLASH_BINS list of binaries to flash 'BINARY_PATH:ddoption1,ddoption2,...[BINARY_PATH:ddoption1,ddoption2,...]'
# e.g.: 
# REDPESK_FLASH_BINS="\
# /usr/lib/firmware/layerscape/firmware_lx2160ardb.img:bs=512,seek=8,conv=fsync \
# /boot/atf/bl2_sd.pbl:bs=512,seek=8,conv=fsync \
# /boot/atf/fip.bin:bs=512,seek=2048,conv=fsync"

set -e

[ -z "$REDPESK_FLASH_BINS" ] &&
	echo "REDPESK_FLASH_BINS env variable not defined please provide it '-E REDPESK_FLASH_BINS='" >&2 &&
	exit 1

IMAGE=$OUTPUTDIR/$(jq -r '.output // "image"' $MKOSI_CONFIG).raw

echo "Flashing the bootloader to the image..."

for DD_OPTS in $REDPESK_FLASH_BINS; do

	FILE_TO_FLASH=$UBOOT_DIR/$(basename $(echo $DD_OPTS | cut -d ':' -f 1))
	OPTS=$(echo $DD_OPTS | cut -d ':' -f 2 | tr ',' ' ')

	( set -x; dd if=$FILE_TO_FLASH of=$IMAGE $OPTS)

done

sync

echo "The bootloader has been correctly flashed to $IMAGE"
