# Shirase

This is my personal nixos dotfiles, always wip.

## Features

### ZFS + Impermanence

Whole volume has 1 GB for boot and 16 GB for swap, the rest are ZFS datasets.
Layout is like below.

```sh
nvme0n1
  ├── NIXOS # zroot
  │     ├── zroot/root
  │     ├── zroot/nix
  │     ├── zroot/tmp
  │     ├── zroot/persist
  │     └── zroot/cache
  ├──── SWAP    - 16 GB
  └──── NIXBOOT -  1 GB
```

root and home on tmpfs but /perisit and /cache are remained by
[impermanence module](https://github.com/nix-community/impermanence).

Plus, /persist volume of my laptop (acer) is transferred to a HDD connected to
my desktop (sakura) using
[Syncoid](https://github.com/jimsalterjrs/sanoid?tab=readme-ov-file#syncoid).

## Install

Some process need to install from a tty on the NixOS iso (minimal)

### (Optinal): Install from another Linux system via SSH

Enable SSH on the target device.

```sh
systemctl start sshd.service
```

Set password for root.

```sh
passwd
```

Look up IP address.

```sh
ip a
```

Now, from the other system, ssh into the target device.

```sh
ssh root@ip_address_of_target-device
```

### (Optional) Using Niri binary cache

Install Cachix client.

```sh
nix-env -iA cachix -f https://cachix.org/api/v1/install
```

Start using the binary cache.

```sh
cachix use niri
```

### Automatically install using a script

Run the following.

```sh
sh <(curl -L https://raw.githubusercontent.com/Sumelan/shirase/main/install.sh)
```

## Credits

- [iynaix/dotfiles](https://github.com/iynaix/dotfiles)

  Shamelessly copied impermanence, install-scripts, and many config from his
  dotfile.

- [Michael-C-Buckley/nixos](https://github.com/Michael-C-Buckley/nixos)

  My dotfile stracture is inspired form his repo.

## Reference

- [Vimjoyer's youtube](https://www.youtube.com/@vimjoyer)

  If you consider using nixos, check his YouTube!
