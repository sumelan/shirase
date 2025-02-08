# Edit justfile.
default:
  @$EDITOR .justfile

# outputs the current nixos generation
[group('nix')]
current:
  nix-current-generation

# nixos-rebuild switch, use different package for home-manager standalone
[group('nix')]
switch:
  nsw

# update all nvfetcher overlays and packages
[group('nix')]
update-all:
  nv-update

# update via nix flake
[group('nix')]
update:
  upd8

# nix garbage collection
[group('nix')]
clean:
  ngc

# utility for creating a nix repl, allows editing within the repl.nix
[group('nix')]
repl:
  nrepl

# build local package if possible, otherwise build config
[group('nix')]
build-local:
  nb

# test all packages that depend on this change, used for nixpkgs and copied from the PR template
[group('nix')]
test-pkgs:
  nb-dependents

# build and run local package if possible, otherwise run from nixpkgs
[group('nix')]
run-local:
  nr

# show path
[group('nix')]
path:
  npath

# creates a file with the symlink contents and renames the original symlink to .orig
[group('nix')]
symlink:
  nsymlink

# show path in yazi
[group('nix')]
path-yazi:
  ynpath

# what depends on the given package in the current nixos install?
[group('nix')]
show-dependents:
  ndepends

# see json
[group('nix')]
json:
  json2nix

# see yaml
[group('nix')]
yaml:
  yaml2nix

# nixos-rebuild boot
[group('nix')]
boot:
  nsb

# nixos-rebuild test
[group('nix')]
test:
  nst
