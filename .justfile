set shell := ["sh", "-c"]

export NH_FLAKE := `echo $PWD`
export HOSTNAME := `hostname`
export NIXPKGS_ALLOW_UNFREE := "1"

# nix-profiles
profiles-path := "/nix/var/nix/profiles"

# package-paths updated through nvfetcher
yazi-path := "packages/yazi-plugins"
helium-path := "packages/helium"

@default:
    just --list --unsorted

[group('SANITY')]
[doc('Check whether the flake evaluates and run its tests.')]
@check:
    nix flake check

[group('SANITY')]
[doc('Analyzing a `flake.lock` for duplicate inputs.')]
@flint:
    nix run github:NotAShelf/flint

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
    if [ -f "bootlog/{{ HOSTNAME }}.log" ]; then \
      echo -e "Write in previous log...\n"; \
    else \
      echo -e "Create new log...\n" && \
      echo -e "\n[New entry]" >> bootlog/{{ HOSTNAME }}.log && \
      echo -e "<<< .\n>>> $(command ls -d1v {{ profiles-path }}/system-*-link | tail -n 1)" >> bootlog/{{ HOSTNAME }}.log; \
    fi

    nh os switch {{ args }}

    echo -e "\n---\n\n$(date '+%x %X')" >> bootlog/{{ HOSTNAME }}.log
    nvd diff \
      "$(command rg -N '>>> ({{ profiles-path }}/system-[0-9]+-link)' --only-matching --replace '$1' bootlog/{{ HOSTNAME }}.log | tail -1)" \
        "$(command ls -d1v {{ profiles-path }}/system-*-link | tail -n 1)" \
          >> bootlog/{{ HOSTNAME }}.log

    git add -A
    echo -e "Commit on git...\n"
    git commit -m "deployed $(nixos-rebuild list-generations --flake $NH_FLAKE --json | jq '.[0].generation') on $(hostname)"

[group('SYSTEM')]
[doc('Update flake and fetch git input with nvfetcher.')]
@get-updates: check
    echo -e "Updating flake and fetch git inputs...\n"

    nix flake update
    # run nvfetcher for yazi-plugins
    nvfetcher --keep-old --config {{ yazi-path }}/nvfetcher.toml --build-dir {{ yazi-path }}
    nvfetcher --keep-old --config {{ helium-path }}/nvfetcher.toml --build-dir {{ helium-path }}

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
[doc('Download a file to the Nix store and get the SHA-256 hash.')]
@prefetch url:
    nix store prefetch-file --json --hash-type sha256 {{ url }} | jq -r .hash

[group('TOOLS')]
[doc('Nix (package manager) indexing primitives.')]
@locate program:
    nix-locate {{ program }}

[group('TOOLS')]
[doc('Look the store path of specific package through yazi.')]
@explore nixpkg:
    yazi $(nix eval --raw nixpkgs#{{ nixpkg }})

alias cb := customBuild

[group('TOOLS')]
[doc('Build a custom package you defined in `./packages`.')]
@customBuild package:
    nix-build --expr '(import <nixpkgs> { }).callPackage ./packages/{{ package }}/default.nix {}'

[group('TOOLS')]
[doc('Start an interactive environment for evaluating Nix expressions.')]
@repl:
    nh os repl
