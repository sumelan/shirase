# Shirase

This is my personal nixos dotfiles, always wip.

## Features

### Btrfs + Impermanence

Whole volume has 1 GB for boot and the rest is btrfs root volumes. Volumes
layout is like below.

```sh
nvme0n1
  ├── NIXOS # Btrfs's Subvolume
  │     ├── /nix
  │     ├── /persist
  │     ├── /cache
  │     ├── /root
  │     └── /root-blank
  └── NIXBOOT
```

Root volume is wiped at each boot via the script but /perisit and /cache are
remained by
[impermanence module](https://github.com/nix-community/impermanence).

Plus, /persist volume of my laptop (acer) is transferred to HDD connected to my
desktop (sakura) over ssh using [btrbk](https://github.com/digint/btrbk).

### Setting per Host

You can set different setting per host; user, package branch, and default
program.

## Automatic Install Script

Run the following commands from a terminal on a NixOS live iso / from a tty on
the minimal iso.

From a standard ISO,

```sh
sh <(curl -L https://raw.githubusercontent.com/Sumelan/shirase/main/install.sh)
```

## Credits

- [iynaix/dotfiles](https://github.com/iynaix/dotfiles)

  Shamelessly copied impermanence, install-scripts, and many config from his
  dotfiles.

- [Guekka's blog](https://guekka.github.io/nixos-server-1/)

  His script is used in my btrfs impermanence setup.

- [Vortriz/dotfiles](https://github.com/Vortriz/dotfiles)

  The .justfile contain many tools.

- [Tyler Kelley/ZaneyOS](https://gitlab.com/Zaney/zaneyos)

  My NixOS journey began from ZaneyOS!
