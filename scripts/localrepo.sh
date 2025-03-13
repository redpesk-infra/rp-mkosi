#!/bin/bash

destrepo=$SRCDIR/mkosi.sandbox/etc/yum.repos.d

[ -z "$REDPESK_DISTRO" ] &&
	echo "REDPESK_DISTRO env variable not defined please provide it '-E REDPESK_DISTRO='" &&
	exit 1

echo "Generate mkosi.repo into $destrepo"

mkdir -p $destrepo
cat << EOF > $destrepo/mkosi.repo
[redpesk-bsp]
name=RedPesk BSP
baseurl=https://download.redpesk.bzh/redpesk-lts/$REDPESK_DISTRO/packages/$REDPESK_BSP/\$basearch/os/
enabled=1
priority=1
metadata_expire=3h
repo_gpgcheck=0
type=rpm
module_hotfixes=1
gpgcheck=0

[redpesk-config]
name=RedPesk Baseos
baseurl=https://download.redpesk.bzh/redpesk-config/
enabled=1
priority=98
metadata_expire=3h
repo_gpgcheck=0
type=rpm
module_hotfixes=1
gpgcheck=0

[redpesk-baseos]
name=RedPesk Baseos
baseurl=https://download.redpesk.bzh/redpesk-lts/$REDPESK_DISTRO/packages/baseos/\$basearch/os/
enabled=1
priority=98
metadata_expire=3h
repo_gpgcheck=0
type=rpm
module_hotfixes=1
gpgcheck=0


[redpesk-middleware]
name=RedPesk middle
baseurl=https://download.redpesk.bzh/redpesk-lts/$REDPESK_DISTRO/packages/middleware/\$basearch/os/
enabled=1
priority=98
metadata_expire=3h
repo_gpgcheck=0
type=rpm
module_hotfixes=1
gpgcheck=0
EOF

