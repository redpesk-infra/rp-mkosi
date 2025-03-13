# redpesk mkosi

## Build image examples

### generic

```
mkosi -I mkosi-generic.conf --debug --force --debug-workspace -E REDPESK_DISTRO=batz-2.0-update --profile smack,minimal,localrepo
```

### rpi

```bash
mkosi -I mkosi-rpi.conf --debug --force --debug-workspace -E REDPESK_DISTRO=batz-2.0-update --profile smack,minimal,localrepo

```

## Organisation

The idea is to have a configuration file by board/bsp and have different
configuration files into mkosi.conf.d/.

There is a default configuration file, load by everybody and after variations
are handled with mkosi profiles.

## Troubleshooting

### fstab

It seems to have an issue with systemd-repart for vfat filesystem with
the volume id/UUID, it should be a 32 bits value in /etc/fstab but it appears
to be an 128 bits by default

Issue opened: https://github.com/systemd/systemd/issues/36735
