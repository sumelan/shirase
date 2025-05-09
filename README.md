<div align="center">

# Wolborg

This is my personal nixos config, always wip.

</div>

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

Btrfs root volume is wiped at each boot via
[the script](https://guekka.github.io/nixos-server-1/), but /perisit and /cache
are remained by
[impermanence module](https://github.com/nix-community/impermanence).

Plus, /persist volume of laptop (acer) is transferred to hdd connected to mini
pc (sakura) over ssh using [btrbk](https://github.com/digint/btrbk).

## Automatic Install Script

Run the following commands from a terminal on a NixOS live iso / from a tty on
the minimal iso.

From a standard ISO,

```sh
sh <(curl -L https://raw.githubusercontent.com/Sumelan/wolborg/main/install.sh)
```

## Credits

- [iynaix/dotfiles](https://github.com/iynaix/dotfiles)

  Shamelessly copied impermanence, install-scripts, and many config from his
  dotfiles.

- [EdenQwQ's gists](https://gist.github.com/EdenQwQ)

  Desktop config is from this gist.

- [MrSom3body/dotfiles](https://github.com/MrSom3body/dotfiles) and
  [Tyler Kelley/ZaneyOS](https://gitlab.com/Zaney/zaneyos)

  Their configs are for hyprland, but should be mentioned.
