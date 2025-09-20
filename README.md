# Shirase

This is my personal nixos dotfiles, always wip.

## Features

### BTRFS + Impermanence

Whole volume has 1 GB for boot, the rest are btrfs root volumes. Layout is like
below.

```sh
nvme0n1
  ├── NIXOS  # Btrfs's Subvolume
  │     ├── /nix
  │     ├── /persist
  │     ├── /cache
  │     ├── /root
  │     └── /root-blank
  └── NIXBOOT # 1 GB
```

Volume `/root` is wiped at each boot via the script but `/perisit` and `/cache`
are remained by [impermanence](https://github.com/nix-community/impermanence).

Plus, `/persist` volume of my laptop (acer) is transferred to a HDD connected to
my desktop (sakura) using [btrbk](https://github.com/digint/btrbk).

## Install

There exists a intall scripts, but some process may be needed before. Start from
a tty on the NixOS iso (minimal) ...

<details>

<summary><h4>(Optinal): Install from another Linux system via SSH</summary></h4>

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

</details>

<details>

<summary><h4>(Optional) Using Niri binary cache</summary></h4>

Install Cachix client.

```sh
nix-env -iA cachix -f https://cachix.org/api/v1/install
```

Start using the binary cache.

```sh
cachix use niri
```

Add `imports = [ ./cachix.nix ]` in `/etc/nixos/configuration.nix`.

</details>

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
