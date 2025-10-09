# Shirase

This is my personal flake.

## Features

### BTRFS + Impermanence

Whole volume has 1 GB for boot and 16 GB for swap, the rest are ZFS datasets.
Layout is like below.

```sh
nvme0n1
  ├── NIXOS # subvolumes
  │     ├── /root
  │     ├── /root-blank
  │     ├── /nix
  │     ├── /persist
  │     └── /cache
  │
  └──── NIXBOOT -  1 GB
```

`/root` volume is wiped at each boot, but `/perisit`
and `/cache` are remained by
[impermanence module](https://github.com/nix-community/impermanence).

Also, `/persist` volume of my laptop (minibook) is transferred to HDDs connected to
my desktop (sakura) using
[btrbk](https://github.com/digint/btrbk).

## Install

Some process may be needed before. Start from a tty on the NixOS iso (minimal) ...

### (Optional): Install from another Linux system via SSH

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
# from other system
ssh root@ip_address_of_target-device
```

### (Optional) Using niri binary cache

Install cachix client.

```sh
nix-env -iA cachix -f https://cachix.org/api/v1/install
```

Start using the binary cache.

```sh
cachix use niri
```

Add `imports = [ ./cachix.nix ]` in `/etc/nixos/configuration.nix`.

### Automatically install using a script

Run the following.

```sh
sh <(curl -L https://raw.githubusercontent.com/Sumelan/shirase/main/install.sh)
```

## Credits

- [iynaix/dotfiles](https://github.com/iynaix/dotfiles)

  Shamelessly copied impermanence, install-scripts, and many configs from his repo.

- [Guekka's blog](https://guekka.github.io/nixos-server-1/)

  His script is used in my btrfs+impermanence setup.

## Reference

- [Vimjoyer's YouTube](https://www.youtube.com/@vimjoyer)

  If you consider using nixos, check his YouTube channel!
