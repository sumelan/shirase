set shell := ["sh", "-c"]

export NH_FLAKE := `echo $PWD`
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
    nix flake check

[group('FLAKE')]
[doc('Create missing lock file entries')]
@lock *flake-url:
    nh flake lock {{ flake-url }}

[group('FLAKE')]
[doc('Analyzing a flake.lock for duplicate inputs.')]
@flint:
    nix run github:NotAShelf/flint

[group('REBUILD')]
[doc('`sudo nixos-rebuild test`.')]
@test *args:
    nh os test {{ args }}

[group('REBUILD')]
[doc('`sudo nixos-rebuild switch`.')]
@switch *args:
    nh os switch {{ args }}

[group('REPL')]
[doc('Start repl.')]
@repl:
    nh os repl

[group('TOOLS')]
[doc('Search for all packages containing specific argments.')]
@locate args:
    nix-locate {{ args }}

[group('TOOLS')]
[doc('Download a file to the nix store and get the SHA-256 hash.')]
@prefetch url:
    nix store prefetch-file --json --hash-type sha256 {{ url }} | jq -r .hash

[group('TOOLS')]
[doc('Look the store path of specific package through yazi.')]
@explore package:
    yazi $(nix eval --raw nixpkgs#{{ package }})

[group('UPDATE')]
[doc('Update a specific input in the flake.')]
@update input:
    echo -e "\n===== Updating {{ input }}... =====\n"
    nix flake update {{ input }}

[group('UPDATE')]
[doc('Update all flake inputs, fetch packages and commit on git.')]
@updates:
    echo -e "\n===== Updating all flake inputs... =====\n"
    nix flake update

    echo -e "\n===== Fetching packages... =====\n"
    nvfetcher --keep-old --config {{ config }} --build-dir {{ sourceDir }}

    echo -e "\n===== Commit on git... =====\n"
    git add -A
    git commit -m "chore: update inputs and fetch packages"

[group('MAINTENANCE')]
[doc('Clean all profiles but keep 5 generations.')]
@gc:
    nh clean all -k 5

[group('MAINTENANCE')]
[doc('Replace identical files in the store by hard links.')]
@optimise:
    nix store optimise -v

[group('BUILD')]
[doc('Look the package built with override through yazi.')]
@override package attrs:
    nix build --impure --expr  '(import <nixpkgs> { }).{{ package }}.override { {{ attrs }} }'
    yazi ./result

[group('BUILD')]
[doc('Look the package you defined as `pkgs.custom` through yazi.')]
@custom package:
    nix build --impure --expr '(import <nixpkgs> { }).callPackage ./modules/packages/{{ package }}/default.nix {}'
    yazi ./result

[group('SYNCTHING')]
[doc('Temporarily use Syncthing in a shell environment.')]
@syncRun:
    nix-shell -p syncthing --run "syncthing --home ~/.config/syncthing/"

[group('SYNCTHING')]
[doc('Generate a new key.cert and key.pem for a deployment.')]
@syncGenerate:
    nix-shell -p syncthing --run "syncthing generate --home ~/.config/syncthing/"

[group('SOPS')]
[doc('Convert a SSH Ed25519 key to an age key.')]
@sopsConvert:
   nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt" 

[group('SOPS')]
[doc('Convert an existing SSH Ed25519 pubkey into an age public key.')]
@sopsConvertPub:
   nix-shell -p ssh-to-age --run "ssh-to-age < ~/.ssh/id_ed25519.pub"

[group('SOPS')]
[doc('Convert a SSH Ed25519 public key targeted to `HOST`.')]
@sopsScan host:
   nix-shell -p ssh-to-age --run 'ssh-keyscan {{ host }} | ssh-to-age' 

[group('SOPS')]
[doc('Edit `.sops.yaml`.')]
@sopsEdit:
  $EDITOR .sops.yaml

[group('SOPS')]
[doc('Edit a secret file inside `sercrets/`.')]
@sopsSecrets file:
    nix-shell -p sops --run "sops secrets/{{ file }}"

[group('SOPS')]
[doc('Update the keys for all secrets inside `secrets/FILE`.')]
@sopsUpdate file:
    nix-shell -p sops --run "sops updatekeys secrets/{{ file }}"

[group('ZFS')]
[doc('Show compress ratio in zfs list output.')]
@zlist:
    zfs list -o name,used,avail,compressratio
