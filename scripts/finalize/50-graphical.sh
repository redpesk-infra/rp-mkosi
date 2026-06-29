#!/bin/bash

# Set graphical.target as the default systemd target in the image root filesystem.
ln -sf /usr/lib/systemd/system/graphical.target "${BUILDROOT}"/etc/systemd/system/default.target
