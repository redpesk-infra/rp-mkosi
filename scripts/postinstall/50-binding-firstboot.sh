#!/bin/bash

set -e

[ -z "$REDPESK_BINDING_LIST" ] && exit 0

RPMS_DIR="$BUILDROOT/var/lib/rp-firstboot/rpms"

shopt -s expand_aliases
alias dnf_firstboot="dnf --installroot=$BUILDROOT"

mkdir -p ${RPMS_DIR}
echo "installing $REDPESK_BINDING_LIST ..."
dnf_firstboot install -y --downloadonly --downloaddir=${RPMS_DIR} ${REDPESK_BINDING_LIST}

#clean dnf cache
dnf_firstboot clean all

# Since first boot RPMs are not installed in the image, they are not listed in manifest.log
rpm -qp ${RPMS_DIR}/*.rpm > $OUTPUTDIR/manifest-firstboot.log

