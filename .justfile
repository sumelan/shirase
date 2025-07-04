# originally form https://github.com/Vortriz/dotfiles

set shell := ["fish", "-c"]

export NH_FLAKE := `echo $PWD`
export HOSTNAME := `hostname`
export NIXPKGS_ALLOW_UNFREE := "1"
profiles-path := "/nix/var/nix/profiles"

@default:
    just --list --unsorted

[group('SANITY')]
[doc('Check whether the flake evaluates and run its tests.')]
@check:
    nix flake check

[group('SYSTEM')]
[doc('Build and activate the new configuration.')]
@test *args:
    nh os test {{ args }}

[group('SYSTEM')]
[doc('Build and activate the new configuration, and make it the boot default.')]
@switch *args:
    nh os switch {{ args }}

[group('SYSTEM')]
[doc('Switch configuration, make boot-default and remain a log, commit on git.')]
@deploy *args: check
    if test -f {{ HOSTNAME }}_build.log; \
      echo -e "Write in previous log...\n"; \
    else; \
      echo -e "Create new log...\n"; \
      echo -e "\n[New entry]" >> {{ HOSTNAME }}_build.log; \
      echo -e "<<< .\n>>> $(command ls -d1v {{ profiles-path }}/system-*-link | tail -n 1)" >> {{ HOSTNAME }}_build.log; \
    end

    nh os switch {{ args }}

    echo -e "\n---\n\n$(date '+%x %X')" >> {{ HOSTNAME }}_build.log
    nvd diff \
      "$(command rg -N '>>> ({{ profiles-path }}/system-[0-9]+-link)' --only-matching --replace '$1' {{ HOSTNAME }}_build.log | tail -1)" \
        "$(command ls -d1v {{ profiles-path }}/system-*-link | tail -n 1)" \
          >> {{ HOSTNAME }}_build.log

    git add -A
    echo -e "Commit on git...\n"
    git commit -m "deployed $(nixos-rebuild list-generations --flake $NH_FLAKE --json | jq '.[0].generation') on $(hostname)"

[group('SYSTEM')]
[doc('Update flake and fetch git input with nvfetcher.')]
@get-updates: check
    echo -e "Updating flake and fetch git inputs...\n"

    nix flake update
    # run nvfetcher for overlays
    nvfetcher --keep-old --config overlays/nvfetcher.toml --build-dir overlays

[group('SYSTEM')]
[doc('Update flake, fetch input and commit on git.')]
@update: get-updates
    git add -A
    echo -e "Commit on git..."
    git commit -m "chore: update inputs"

[group('MAINTENANCE')]
[doc('Clean all profiles but keep 5 generations.')]
@gc:
    nh clean all -k 5

[group('MAINTENANCE')]
[doc('Replace identical files in the store by hard links.')]
@optimise:
    nix store optimise -v

alias pf := prefetch

[group('TOOLS')]
[doc('Download a file to the Nix store and get the SHA-512 hash.')]
@prefetch url:
    nix store prefetch-file --json --hash-type sha512 {{ url }} | jq -r .hash

[group('TOOLS')]
[doc('Fuzzy search for NixOS packages with nix-search-tv.')]
@search:
    ns

[group('TOOLS')]
[doc('Look the store path of specific package through yazi.')]
@explore name:
    yazi $(nix eval --raw nixpkgs#{{ name }})

[group('TOOLS')]
[doc('Start an interactive environment for evaluating Nix expressions.')]
@repl:
    nix repl --expr \
    "let \
        flake = builtins.getFlake (toString ./.); \
        nixpkgs = import <nixpkgs> {}; \
    in \
        {inherit flake;} // flake // builtins // nixpkgs // nixpkgs.lib // flake.nixosConfigurations"
