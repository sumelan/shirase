<div align="center">

## Wolborg

This is my personal nixos config.  always wip.

</div>

## Feature
### Btrfs + impermanence

I set 1GB boot and rest is btrfs root(/) volume. My subvolumes under root is like this.

```sh
NIXOS
├── nix
├── persist
└── cache
───NIXBOOT
```

Btrfs root volume is wiped at each boot via [the scripts](https://guekka.github.io/nixos-server-1/), but /perisit and /cache are remained by [impermanence module](https://github.com/nix-community/impermanence).

Plus, my laptop(acer)'s /persist is transferred to my mini pc(sakura)'s hdd over ssh using [btrbk](https://github.com/digint/btrbk).


## How to Install
Run the following commands from a terminal on a NixOS live iso / from a tty on the minimal iso.

From a standard ISO,
```sh
sh <(curl -L https://raw.githubusercontent.com/Sumelan/wolborg/main/install.sh)
```

## Credits

- [iynaix/dotfiles](https://github.com/iynaix/dotfiles)

  I shamelessly copied impermanence, install-scripts, and many config from his dotfiles.

- [EdenQwQ's gists](https://gist.github.com/EdenQwQ)

  Wallpaper lutgen and blur feature is from this gist.

  ### and many from /unixporn!
