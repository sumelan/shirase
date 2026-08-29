set shell := ["nu", "-c"]

# env
export NH_FLAKE := `echo $env.PWD`
export HOSTNAME := `hostname`
export NIXPKGS_ALLOW_UNFREE := "1"

[group('DEFAULT')]
[doc('List the recipes.')]
@default:
    just --list --unsorted

[group('FLAKE')]
[doc('Check whether the flake evaluates and run its tests.')]
@check:
    git add -A
    nix flake check

[group('REBUILD')]
[doc('`nh os test`.')]
@test *opts:
    git add -A
    nh os test {{ opts }}

[group('REBUILD')]
[doc('`nh os switch`.')]
@switch *opts:
    git add -A
    nh os switch {{ opts }}

[group('CLEAN')]
[doc('Clean all profiles but keep 5 generations.')]
@clean:
    nh clean all --keep 5

[group('UPDATE')]
[doc('Update inputs interactively.')]
@update:
    tack-update-diff
    git add -A

[group('GIT')]
[doc('Show changes between commit and working tree.')]
@diff:
    git add -A
    comview watch -- git diff main

[group('GIT')]
[doc('Show HEAD.')]
@show:
    git add -A
    comview watch -- git show HEAD

[group('OPTIMISE')]
[doc('Replace identical files in the store by hard links.')]
@optimise:
    nix-store --optimise -v

[group('EVAL')]
[doc('Measure eval time on each host.')]
@eval:
    hyperfine 'nix eval .#nixosConfigurations.{{ HOSTNAME }}.config.system.build.toplevel --substituters " " --option eval-cache false --raw --read-only'

[group('EVAL')]
[doc('Create the flamegraph file of eval time and open in browser.')]
@graph:
    nix-shell -p nixVersions.latest inferno --command \
        "nix eval .#nixosConfigurations.{{ HOSTNAME }}.config.system.build.toplevel --impure --eval-profiler flamegraph --eval-profiler-frequency 9999 \
            && inferno-flamegraph --width 10000 < nix.profile > wrappers.svg \
                && helium wrappers.svg"
