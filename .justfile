set shell := ["nu", "-c"]

# env
export NH_FLAKE := `echo $env.PWD`
export HOSTNAME := `hostname`
export NIXPKGS_ALLOW_UNFREE := "1"

# package-paths fetched through nvfetcher
config := ".config/nvfetcher.toml"
sourceDir := "_sources"

[group('DEFAULT')]
[doc('List the recipes.')]
@default:
    just --list --unsorted

[group('FLAKE')]
[doc('Check whether the flake evaluates and run its tests.')]
@check:
    git add -A
    nix flake check

[group('FLAKE')]
[doc('Create missing lock file entries')]
@lock *flake-url:
    nix flake lock {{ flake-url }}

[group('FLAKE')]
[doc('Analyzing a flake.lock for duplicate inputs.')]
@flint:
    nix run github:NotAShelf/flint

[group('REBUILD')]
[doc('`nh os test`.')]
@test *args:
    git add -A
    nh os test {{ args }}

[group('REBUILD')]
[doc('`nh os switch`.')]
@switch *args:
    git add -A
    nh os switch {{ args }}

[group('UPDATE')]
[doc('Update a specific input in the flake.')]
@update input:
    print ''
    print $'(ansi cyan)---- Updating (ansi green_italic)(ansi attr_underline){{ input }}(ansi rst)(ansi cyan)... ----(ansi rst)'
    nix flake update {{ input }}

[group('UPDATE')]
[doc('Update all flake inputs, fetch packages and commit on git.')]
@updates:
    print ''
    print $'(ansi cyan)---- Updating (ansi green_italic)(ansi attr_underline)all inputs(ansi rst)(ansi cyan)... ----(ansi rst)'
    nix flake update

    print ''
    print $'(ansi cyan)---- Fetching (ansi green_italic)(ansi attr_underline)all packages(ansi rst)(ansi cyan)... ----(ansi rst)'
    nvfetcher --keep-old --config {{ config }} --build-dir {{ sourceDir }}

    print ''
    print $'(ansi cyan)---- Commit on git... ----(ansi rst)'
    git add -A
    git commit -m "chore: update inputs and fetch packages"

[group('MAINTENANCE')]
[doc('Clean all profiles but keep 5 generations.')]
@gc:
    nh clean all -k 5

[group('MAINTENANCE')]
[doc('Replace identical files in the store by hard links.')]
@optimise:
    nix-store --optimise -v

[group('LOCATE')]
[doc('Search for all packages containing specific library.')]
@liblc lib:
    nix-locate -- "lib/{{ lib }}" | rg -v '^\('

[group('PACKAGE')]
[doc('Look the store path through yazi. If path not found, build it.')]
@yp pkg:
    #!/usr/bin/env nu
    let PKG_DIR = (nix eval --impure --raw "nixpkgs#{{ pkg }}.outPath")
    if not  ( $PKG_DIR | path exists) {
        nix build "nixpkgs#{{ pkg }}" --print-out-paths | awk '{ print length, $0 }' | cut -d" " -f2- | head -n1;
    }
    yazi $PKG_DIR

[group('PACKAGE')]
[doc('Look the package built with override attrs through yazi.')]
@yor pkg attrs:
    nix build --impure --expr  '(import <nixpkgs> { }).{{ pkg }}.override { {{ attrs }} }'
    yazi ./result

[group('EVAL')]
[doc('Measure eval time on each host.')]
@eval:
    hyperfine 'nix eval .#nixosConfigurations.{{ HOSTNAME }}.config.system.build.toplevel --substituters " " --option eval-cache false --raw --read-only'

[group('EVAL')]
[doc('Create the flamegraph file of eval time and open in browser.')]
@geval:
    nix-shell -p nixVersions.latest inferno --command \
        "nix eval .#nixosConfigurations.{{ HOSTNAME }}.config.system.build.toplevel --impure --eval-profiler flamegraph --eval-profiler-frequency 9999 \
            && inferno-flamegraph --width 10000 < nix.profile > wrappers.svg \
                && helium wrappers.svg"
