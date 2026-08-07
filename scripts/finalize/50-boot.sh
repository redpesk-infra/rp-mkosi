#!/bin/bash

# Copying all symlinks by their target
# This could be done using a profile

echo "Fixing symlink in boot..."
(
	set -x
	ls -l $BUILDROOT/boot
)

for sym in $(find $BUILDROOT/boot -type l); do
	target=$(readlink -f "$sym")

	[ -f "$target" ] || continue

	(
		set -x
		rm -f "$sym"
		cp -f "$target" "$sym"
	)
done
