# nix shell nixpkgs#just nixpkgs#nushell
set shell := ["fish", "-c"]

default:
    @just --list
# Rebuild
[group('nix')]
fr:
    nh os switch

# Flake Update
[group('nix')]
fu:
    nh os switch --update

# Update specific input
# Usage: just upp nixpkgs
[group('nix')]
upp input:
    nix flake update {{input}}
# Test
[group('nix')]
ft:
    nh os test
# Collect Garbage
[group('nix')]
ncg:
    nix-collect-garbage --delete-old ; sudo nix-collect-garbage -d ; sudo /run/current-system/bin/switch-to-configuration boot

[group('nix')]
cleanup:
    nh clean all

