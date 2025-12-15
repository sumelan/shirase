# Shirase

This is my personal flake.

## Features

### Full Disk Encryption + Impermanence

My system consists from encrypted btrfs and
[Impermanence](https://github.com/nix-community/impermanence). System rolls back
to `/root-blank` volume on each boot but some volumes remain. As snapshots and
backup tool, I use [btrbk](https://github.com/digint/btrbk).

```sh
nvme0n1
  │
  ├─ NIXOS # subvolumes
  │    ├── /root-blank
  │    ├── /root
  │    ├── /nix
  │    ├── /log
  │    ├── /persist
  │    ├── /cache
  │    └── /snapshots
  │
  └─ NIXBOOT -  1 GB
```

### Custom Neovim

My flake includes custom neovim packages configured by
[nvf](https://github.com/NotAShelf/nvf). Those are separated to `nvfMini` and
`nvf`. Both are portable and you can use my neovim on other nix-installed
system.

```sh
nix run github:sumelan/shirase#nvf
```

`nvfMini` is minimal and focus on only editting nix files.

## Resource

- [Full Disk Encryption and Impermanence on NixOS](https://notashelf.dev/posts/impermanence)
  His site helps me to configure my flake. Also I rely on many programs he
  involved with (nh, nvf, flint, and more!)

- [iynaix/dotfiles](https://github.com/iynaix/dotfiles)

  I shamelessly copied many configs from his repo.

- [Vimjoyer's YouTube](https://www.youtube.com/@vimjoyer)

  If you consider using nixos, check on his YouTube channel!
