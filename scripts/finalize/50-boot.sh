#!/usr/bin/env bash
set -euo pipefail

: "${BUILDROOT:?BUILDROOT is not set. This script must run as a mkosi finalize script, not postoutput.}"

image="/boot/Image"
image_full="${BUILDROOT}${image}"

resolve_in_buildroot() {
    local path="$1"
    local full="${BUILDROOT}${path}"
    local link
    local dir
    local depth=0

    while [ -L "$full" ]; do
        if [ "$depth" -gt 20 ]; then
            echo "Too many symbolic link levels for $path" >&2
            exit 1
        fi

        link="$(readlink "$full")"

        if [[ "$link" = /* ]]; then
            path="$link"
        else
            dir="$(dirname "$path")"
            path="$(realpath -m "$dir/$link")"
        fi

        full="${BUILDROOT}${path}"
        depth=$((depth + 1))
    done

    if [ ! -f "$full" ]; then
        echo "Resolved kernel image is not a regular file: $full" >&2
        exit 1
    fi

    printf '%s\n' "$full"
}

if [ -L "$image_full" ]; then
    target="$(resolve_in_buildroot "$image")"
    tmp="$(mktemp "${BUILDROOT}/boot/.Image.XXXXXX")"

    echo "Replacing /boot/Image symlink with regular file copied from ${target#"$BUILDROOT"}" >&2

    cp --preserve=mode,timestamps "$target" "$tmp"

    rm -f "$image_full"
    mv "$tmp" "$image_full"

elif [ -f "$image_full" ]; then
    echo "/boot/Image is already a regular file" >&2
else
    echo "/boot/Image does not exist in BUILDROOT" >&2
fi
