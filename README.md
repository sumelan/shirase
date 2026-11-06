# Shirase

My personal NixOS flake: an encrypted ZFS root that resets on every boot, plus a set of portable wrapped packages.

This is *my* configuration — fork it and replace the hosts rather than using it verbatim.

## Features

### Filesystem: ZFS + preservation

The system lives on an encrypted disk and returns to a pristine state on every boot. To roll the root dataset back, a systemd service runs after the base zpool is imported but before the root filesystem is mounted.

### Wrapping: pre-bundled: configuration

Several packages here are wrapped with a configuration baked in. They are portable: you can run them on any NixOS system without touching that host's own settings.

Some wrapped packages accept an `extraConfig` attribute set, so you can run them with your own settings merged in. `.override` needs `--impure`, because the expression calls `builtins.getFlake` and `builtins.currentSystem`:

```sh
nix run --impure --expr '
  let
    repo = builtins.getFlake "github:sumelan/shirase";
    system = builtins.currentSystem;
  in
  repo.packages.${system}.helix.override {
    extraConfig = {
      editor.line-number = "absolute";
    };
  }
'
```

`helix` additionally accepts extraLang and extraRuntimeInputs; check the package's `.nix` file under `packages/wrapped/` for what it takes.

Each wrapped package also ships one or more executables that print the configuration baked into it. The names follow the wrapped program, not the attribute name (helix → hx-print-config):

```sh
nix shell github:sumelan/shirase#helix -c hx-print-config
nix shell github:sumelan/shirase#helix -c hx-print-language
```

To see every program a package provides:

```sh
ls "$(nix build github:sumelan/shirase#helix --no-link --print-out-paths)/bin"
```

Note that `nix run` only ever starts the package's `meta.mainProgram`, so use `nix shell … -c` when you want a secondary executable.

## Install

A script sets up the partition table and the zpool:

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/sumelan/shirase/main/partition.sh)
```

I know disko exists, but I prefer this approach.

Before nixos-install, one step is still required: writing a hardware configuration for the target host. The filesystem mounts are already defined in this flake, but hardware-specific settings are not. Generate one with:

```sh
nixos-generate-config --no-filesystems --show-hardware-config \
  > /tmp/hardware-configuration.nix
```

Commit it for the host you are installing, then run the install:

```sh
sudo nixos-install \
  --no-root-password \
  --flake "github:sumelan/shirase/main#HOST" \
  --option tarball-ttl 0
```

`HOST` is one of the names under `hosts/`. `--option tarball-ttl 0` avoids installing a cached, stale copy of this flake.

## Resources
- Inspired by these dotfiles:
[iynaix/dotfiles](https://github.com/iynaix/dotfiles),
[Michael-C-Buckley/nixos](https://github.com/Michael-C-Buckley/nixos),
[poz/niksos](https://git.poz.pet/poz/niksos)

- [Vimjoyer's YouTube](https://www.youtube.com/@vimjoyer) -- a good starting point if you are considering NixOS.
