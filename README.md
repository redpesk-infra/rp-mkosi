# redpesk mkosi

mkosi is a systemd tool that generates disk images [https://mkosi.systemd.io](https://mkosi.systemd.io).

For RedPesk, the main goal is that it uses systemd-repart for making gpt
partitionning without any priviledge using libfdisk [https://www.freedesktop.org/software/systemd/man/latest/systemd-repart.html](https://www.freedesktop.org/software/systemd/man/latest/systemd-repart.html).

Have a look on the man page for more information:

```
mkosi --help
```

or directly online on mkosi github
[https://github.com/systemd/mkosi/blob/main/mkosi/resources/man/mkosi.1.md](https://github.com/systemd/mkosi/blob/main/mkosi/resources/man/mkosi.1.md)

## Simple Examples

In simple-examples directory, find "flat" configuration. In the idea to be
get and modify much easily than in the root part of the repository. There are
only one configuration file and no profiles.

To try it for having RedpeskOS on rpi do:

```
cd simple-examples/rpi
mkosi
```

And the image should be in the output directory.

## Simple Examples

In the `simple-examples` directory, you will find a **flat configuration**.
The idea is to make it easier to understand and to modify than in the root configuration of the repository.
There is only one configuration file and no profiles.

To build a RedpeskOS image for rpi, run:

```bash
cd simple-examples/rpi
mkosi
```

The generated image will be available in the `output` directory.

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

* `mkosi-*board*.conf` the entry config file for a specfic board
* `mkosi.conf.d` the directory of snippet of configuration files,
many of then can be activated passing profiles
    * `default.conf` default/common configuration
* `repart.d` the directory of snippet of partitions for systemd-repart
* `scripts` the directory of scripts executed during the image build

## systemd-repart

The image and partitions creation is done with systemd-repart, follow the
repart.d documentation to describe partitions:
[https://www.freedesktop.org/software/systemd/man/249/repart.d.html](https://www.freedesktop.org/software/systemd/man/249/repart.d.html)


There are examples in sub-directories of repart.d/

There is also an issue with fstab generation: see Troubleshooting section,
there is a fix in rp-mkosi, to activate it set the environnment variable
`Environment=REDPESK_FIX_FSTAB=1`.

## Troubleshooting

### fstab

It seems to have an issue with systemd-repart for vfat filesystem with
the volume id/UUID, it should be a 32 bits value in /etc/fstab but it appears
to be an 128 bits by default

Issue opened: [https://github.com/systemd/systemd/issues/36735](https://github.com/systemd/systemd/issues/36735)

### *Dynamic* Profiles/Include

In snippet configuration, if a new profile is wanted, it needs to be set and
included, indeed conf files are only parsed once so if the minimal profile
needs to be append see the example below:

```
# myconf.conf that append minimal
[Config]
Profiles=minimal # add minimal profile in the profiles list

[Include]
Include=mkosi.conf.d/minimal.conf # load minimal.conf
```

It also works for conditionnal includes, see the afb example to load the
afb-app-manager either for smack nor selinux:

```
# afb.conf
[Config]
Profiles=afb

[Include]
Include=mkosi.conf.d/afb-smack.conf
Include=mkosi.conf.d/afb-selinux.conf
...

# afb-selinux.conf

...
[TriggerMatch]
Profiles=selinux
Profiles=afb
```

In this example, the two files afb-smack and afb-selinux are included
but as it is written in the `TriggerMatch` of afb-selinux,
it needs the afb and the selinux profile to be triggered.
