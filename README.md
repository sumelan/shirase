# Shirase

This is my personal nixos dotfiles, always wip.

## Features

### Btrfs + Impermanence

My nixos has 1 GB for boot and the rest is btrfs root volumes. Whole volumes is
like below.

```sh
nvme0n1
  ├── NIXOS
  │     ├── /nix
  │     ├── /persist
  │     ├── /cache
  │     ├── /root
  │     └── /root-blank
  └── NIXBOOT
```

Btrfs root volume is wiped at each boot via the script but /perisit and /cache
are remained by
[impermanence module](https://github.com/nix-community/impermanence).

Plus, /persist volume of my laptop (acer) is transferred to hdd connected to my
desktop (sakura) over ssh using [btrbk](https://github.com/digint/btrbk).

### Modularization

I use [home-manager](https://github.com/nix-community/home-manager) to manage my
config. Each program file is contained the all configs related to that program,
so i just exclude its file and all related setting excluded when i stop using
it.

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

  Thank you for his scripts, i can setup impermanence.

- [tiredofit/nixos-config](https://github.com/tiredofit/nixos-config)

  Structure in flake.nix is refered form his repo.

- [EdenQwQ's gists](https://gist.github.com/EdenQwQ)

  Niri's config is from this gist.

- [MrSom3body/dotfiles](https://github.com/MrSom3body/dotfiles) and
  [Tyler Kelley/ZaneyOS](https://gitlab.com/Zaney/zaneyos)

  This two dotfiles are for hyprland, but should be mentioned.
