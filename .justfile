set shell := ["sh", "-c"]

export NH_FLAKE := `echo $PWD`
export HOSTNAME := `hostname`
export NIXPKGS_ALLOW_UNFREE := "1"

# package-paths fetched through nvfetcher
vicinae-path := "modules/packages/vicinae-extensions"
yazi-path := "modules/packages/yazi-plugins"
helium-path := "modules/packages/helium"

alias convert := sopsAge
alias convertPub := sopsAgePublic
alias convertHost := sopsAgeHost

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
[doc('`sudo nixos-rebuild test`.')]
@test *args:
    nh os test {{ args }}

[group('SYSTEM')]
[doc('`sudo nixos-rebuild switch`.')]
@switch *args:
    nh os switch {{ args }}

[group('UPDATE')]
[doc('Update a specific input in the `flake.nix`.')]
@updateInput input: check
    echo -e "\n===== Updating {{ input }}... =====\n"

    nix flake update {{ input }}

alias update := updateInput

[group('UPDATE')]
[doc('Update all flake inputs, fetch packages and commit on git.')]
@updateAll: check
    echo -e "\n===== Updating all flake inputs... =====\n"

    nix flake update

    echo -e "\n===== Fetching a vicinae-extension package... =====\n"

    nvfetcher --keep-old --config {{ vicinae-path }}/nvfetcher.toml --build-dir {{ vicinae-path }}

    echo -e "\n===== Fetching yazi-plugin packages... =====\n"

    nvfetcher --keep-old --config {{ yazi-path }}/nvfetcher.toml --build-dir {{ yazi-path }}

    echo -e "\n===== Fetching a helium package... =====\n"

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
[doc('Build a package in nixpkgs with override.')]
@override package attrs:
    nix build --impure --expr  '(import <nixpkgs> { }).{{ package }}.override { {{ attrs }} }'

[group('BUILD')]
[doc('Build a package you defined under `modules/packages`.')]
@callPackage package:
    nix build --impure --expr '(import <nixpkgs> { }).callPackage ./modules/packages/{{ package }}/default.nix {}'

[group('SYNCTHING')]
[doc('Temporarily use Syncthing in a shell environment.')]
@syncthingRun:
    nix-shell -p syncthing --run syncthing

[group('SYNCTHING')]
[doc('Generate a new key.cert and key.pem for a deployment.')]
@syncthingGenerate:
    nix-shell -p syncthing --run "syncthing generate --home ~/syncthing_key/"

[group('SOPS')]
[doc('Convert an ssh ed25519 key to an age key.')]
@sopsAge:
   nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt" 

[group('SOPS')]
[doc('Convert an existing SSH key into an `age` public key.')]
@sopsAgePublic:
   nix-shell -p ssh-to-age --run "ssh-to-age < ~/.ssh/id_ed25519.pub"

[group('SOPS')]
[doc('Convert an SSH Ed25519 public key targeted to `host`.')]
@sopsAgeHost host:
   nix-shell -p ssh-to-age --run 'ssh-keyscan {{ host }} | ssh-to-age' 

[group('SOPS')]
[doc('Add secrets in `file`.')]
@sopsEdit file:
    nix-shell -p sops --run "sops secrets/{{ file }}"

[group('SOPS')]
[doc('Update the keys in `file` for all secret.')]
@sopsUpdate file:
    nix-shell -p sops --run "sops updatekeys secrets/{{ file }}"`

[group('TOOLS')]
[doc('Start repl.')]
@repl:
    nh os repl

[group('TOOLS')]
[doc('Search for all packages containing `file`.')]
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

