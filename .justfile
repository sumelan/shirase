set shell := ["sh", "-c"]

export NH_FLAKE := `echo $PWD`
export HOSTNAME := `hostname`
export NIXPKGS_ALLOW_UNFREE := "1"

# package-paths fetched through nvfetcher
yazi-path := "modules/packages/yazi-plugins"
helium-path := "modules/packages/helium"

[group('DEFAULT')]
[doc('List the recipes.')]
@default:
    just --list --unsorted

[group('FLAKE')]
[doc('Check whether the flake evaluates and run its tests.')]
@check:
    nix flake check

[group('FLAKE')]
[doc('Create missing lock file entries')]
@lock *flake-url:
    nh flake lock {{ flake-url }}

[group('FLAKE')]
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
[doc('Update a specific input in the `flake.nix`.')]
@updateInput input: check
    echo -e "\n===== Updating {{ input }}... =====\n"

    nix flake update {{ input }}

alias update := updateInput

[group('SYSTEM')]
[doc('Update all flake inputs, fetch some packages by `nvfetcher` and commit on git.')]
@updateAll: check
    echo -e "\n===== Updating all flake inputs... =====\n"

    nix flake update

    echo -e "\n===== Fetching yazi-plugin packages... =====\n"

    nvfetcher --keep-old --config {{ yazi-path }}/nvfetcher.toml --build-dir {{ yazi-path }}

    echo -e "\n===== Fetching helium package... =====\n"

    nvfetcher --keep-old --config {{ helium-path }}/nvfetcher.toml --build-dir {{ helium-path }}

    git add -A
    echo -e "\n===== Commit on git... =====\n"
    git commit -m "chore: update inputs and fetch packages"

alias updates := updateAll

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
[doc('Build a package you defined in `modules/packages/defalut.nix`.')]
@buildCustom package:
    nix build --expr '(import <nixpkgs> { }).callPackage ./modules/packages/{{ package }}/default.nix {}'

alias callPackage := buildCustom

[group('TOOLS')]
[doc('Start an interactive environment for evaluating Nix expressions.')]
@repl:
    nh os repl

[group('TOOLS')]
[doc('Start an interactive shell and run `cmd` based on a Nix expression.')]
@shell program cmd:
    nix-shell -p {{ program }} --run '{{ cmd }}'

[group('TOOLS')]
[doc('Search for all packages containing a file matching `file` or a file named `file`.')]
@locate file:
    nix-locate {{ file }}

[group('TOOLS')]
[doc('Download a file to the nix store and get the SHA-256 hash.')]
@prefetch url:
    nix store prefetch-file --json --hash-type sha256 {{ url }} | jq -r .hash

[group('TOOLS')]
[doc('Look the store path of specific package through yazi.')]
@explore package:
    yazi $(nix eval --raw nixpkgs#{{ package }})

