# Shirase

This is my personal flake.

## Features

### Full Disk Encrtption + Impermanence

My system consists from encrypted btrfs and
[Impermanence](https://github.com/nix-community/impermanence). System rolls back
to `/root-blank` volume on each boot, but `/persist` and `/cache` are remained.
Plus I use [btrbk](https://github.com/digint/btrbk) to take snapshots and backup
my `/persist` volume (`/cache` are files that should be persisted, but not to
snapshot).

```sh
nvme0n1
  │
  ├─ NIXOS # subvolumes
  │    ├── /root-blank
  │    ├── /root
  │    ├── /nix
  │    ├── /home
  │    ├── /log
  │    └── /persist
  │
  ├─ Swap (depends by host)
  │
  └─ NIXBOOT -  1 GB
```

## Optional Steps

After partitioning, there are some processes before install. These are optional
but I always follow these steps.

### Install from another Linux system via SSH

Enable SSH on the target device. Start and complete whole process from target
device only is good if you have a install script or use disko, but I prefer
manually partitioning and install.

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

### Using niri binary cache

I use niri-unstable so it produces building process without the cachix
[niri-flake](https://github.com/sodiboo/niri-flake) provided. My hosts include
poor devices so buiding often result to fail. First, istall cachix client in nix
minimal iso.

```sh
nix-env -iA cachix -f https://cachix.org/api/v1/install
```

Start using the binary cache.

```sh
cachix use niri
```

Add `imports = [ ./cachix.nix ]` in `/etc/nixos/configuration.nix` and run
`sudo nixos-rebuild switch`.

## Resource

- [Full Disk Encryption and Impermanence on NixOS](https://notashelf.dev/posts/impermanence)
  His site helps me to configure my flake. Also I rely on many programs he
  involved with (nh, nvf, flint, and more!)

- [iynaix/dotfiles](https://github.com/iynaix/dotfiles)

  I shamelessly copied many configs from his repo.

- [Vimjoyer's YouTube](https://www.youtube.com/@vimjoyer)

  If you consider using nixos, check on his YouTube channel!
