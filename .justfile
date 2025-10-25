set shell := ["sh", "-c"]

export NH_FLAKE := `echo $PWD`
export HOSTNAME := `hostname`
export NIXPKGS_ALLOW_UNFREE := "1"

# nix-profiles
profiles-path := "/nix/var/nix/profiles"

# package-paths updated through nvfetcher
yazi-path := "packages/yazi-plugins"
helium-path := "packages/helium"

[group('DEFAULT')]
[doc('List the recipes.')]
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
[doc('Switch configuration, make it boot default and write outputs in log, commit on git.')]
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
[doc('Update a specific input in the flake.')]
@updateInput input: check
    nix flake update {{ input }}

alias update := updateInput

[group('SYSTEM')]
[doc('Update all flake inputs, fetch packages you defined and commit on git.')]
@updateAll: check
    echo -e "Updating all flake inputs...\n"

    nix flake update

    echo -e "Fetch packages you defined...\n"

    nvfetcher --keep-old --config {{ yazi-path }}/nvfetcher.toml --build-dir {{ yazi-path }}
    nvfetcher --keep-old --config {{ helium-path }}/nvfetcher.toml --build-dir {{ helium-path }}

    git add -A
    echo -e "Commit on git..."
    git commit -m "chore: update inputs and fetch packages"

alias updates := updateAll

[group('SYSTEM')]
[doc('Start an interactive environment for evaluating Nix expressions.')]
@repl:
    nh os repl

[group('MAINTENANCE')]
[doc('Clean all profiles but keep 5 generations.')]
@gc:
    nh clean all -k 5

[group('MAINTENANCE')]
[doc('Replace identical files in the store by hard links.')]
@optimise:
    nix store optimise -v

[group('BUILD')]
[doc('Build a package in nixpkgs.')]
@build package:
    nix build nixpkgs#{{ package }}

[group('BUILD')]
[doc('Build a package in nixpkgs with override.')]
@buildOverride package override:
    nix build --impure --expr  '(import <nixpkgs> { }).{{ package }}.override { {{ override }} }'

alias override := buildOverride

[group('BUILD')]
[doc('Build a package you defined in `./packages`.')]
@buildCustom package:
    nix build --expr '(import <nixpkgs> { }).callPackage ./packages/{{ package }}/default.nix {}'

alias callPackage := buildCustom

[group('TOOLS')]
[doc('Download a file to the nix store and get the SHA-256 hash.')]
@prefetch url:
    nix store prefetch-file --json --hash-type sha256 {{ url }} | jq -r .hash

[group('TOOLS')]
[doc('Nix (package manager) indexing primitives.')]
@locate program:
    nix-locate {{ program }}

[group('TOOLS')]
[doc('Look the store path of specific package through yazi.')]
@explore package:
    yazi $(nix eval --raw nixpkgs#{{ package }})

