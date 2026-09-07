#!/bin/bash

# redpesk postoutput: bmap/compress/sha256

output="$OUTPUTDIR/$(jq -r '.output // "image"' "$MKOSI_CONFIG").raw"

# link hard image.aw to Redpesk-OS.img
ln $output $OUTPUTDIR/Redpesk-OS.img

if [ "${REDPESK_HYBRID_MBR:-}" = "1" ]; then
	./scripts/postoutput/10-hybrid-mbr.py "$output"
fi

[ "$REDPESK_BYPASS_POSTOUTPUT" ] && exit 0

{ # bmaptool
	! which bmaptool &> /dev/null && echo "no bmaptool found, no bmap file generation" && exit 0
	{ (set -x; bmaptool create $output > ${output}.bmap); echo "bmap done"; } &
}

{ #tar
	! which tar &> /dev/null && echo "no tar, no archive generation" && exit 0
	{ cd $OUTPUTDIR; (set -x; tar --sparse -cJf ${output}.tar.xz Redpesk-OS.img); echo "compression done"; } &
}

{ #sha256
	! which sha256sum &> /dev/null && echo "no sha256sum, no checksum file generation" && exit 0
	{ cd $OUTPUTDIR; (set -x; sha256sum $(basename ${output}) > ${output}.sha256); echo "sha256 done"; } &
}

wait
