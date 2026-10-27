set shell := ["nu", "-c"]

# env
export NH_FLAKE := `echo $env.PWD`
export HOSTNAME := `hostname`
export NIXPKGS_ALLOW_UNFREE := "1"
export NIX_SHOW_STATS := "1"

[group('DEFAULT')]
[doc('List the recipes.')]
@default:
    just --list --unsorted

[group('CHECK')]
[doc('Check whether the flake evaluates and run its tests.')]
@check:
    git add -A
    nix flake check

[group('OPTIMISE')]
[doc('Replace identical files in the store by hard links.')]
@optimise:
    nix-store --optimise -v

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
    comview watch -- git diff HEAD
    git add -A

[group('GIT')]
[doc('Show HEAD.')]
@show:
    comview watch -- git show HEAD
    git add -A

[group('EVAL')]
[doc('Measure eval time on each host.')]
@eval:
    hyperfine 'nix eval .#nixosConfigurations.{{ HOSTNAME }}.config.system.build.toplevel --substituters " " --option eval-cache false --raw --read-only'

[group('EVAL')]
[doc('Write a JSON file that contains nix evaluator stats.')]
@stats:
    nix eval .#nixosConfigurations.{{ HOSTNAME }}.config.system.build.toplevel --substituters " " --option eval-cache false --raw --read-only


