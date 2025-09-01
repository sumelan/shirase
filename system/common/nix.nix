{
  lib,
  config,
  pkgs,
  inputs,
  self,
  user,
  ...
}: let
  inherit
    (lib)
    mkOverride
    mapAttrsToList
    mapAttrs
    sort
    concatStringsSep
    ;

  inherit
    (lib.custom.tmpfiles)
    mkCreateAndRemove
    ;
in {
  services.envfs.enable = true; # execute shebangs that assume hardcoded shell paths
  system = {
    # envfs sets usrbinenv activation script to "" with mkForce
    activationScripts.usrbinenv = mkOverride (50 - 1) ''
      if [ ! -d "/usr/bin" ]; then
        mkdir -p /usr/bin
        chmod 0755 /usr/bin
      fi
    '';

    # this code will be added to the builder creating the system store path.
    # make a symlink of flake within the generation (e.g. /run/current-system/src)
    extraSystemBuilderCmds = "ln -s ${self.sourceInfo.outPath} $out/src";
  };

  # run unpatched binaries on nixos
  programs.nix-ld.enable = true;

  environment = {
    # for nixlang / nixpkgs
    systemPackages = with pkgs; [
      nix-init
      nix-update
    ];
  };

  systemd.tmpfiles.rules =
    # cleanup nixpkgs-review cache on boot
    mkCreateAndRemove "${config.hm.xdg.cacheHome}/nixpkgs-review" {
      mode = "1775";
      inherit user;
      group = "users";
      age = "5d";
    }
    # cleanup channels so nix stops complaining
    ++ mkCreateAndRemove "/nix/var/nix/profiles/per-user/root" {
      mode = "1775";
      user = "root";
      group = "root";
      age = "1d";
    };

  # never going to read html docs locally
  documentation = {
    enable = false;
    doc.enable = false;
    man.enable = false;
    dev.enable = false;
  };

  nix = let
    nixPath = mapAttrsToList (name: _: "${name}=flake:${name}") inputs;
    registry = mapAttrs (_: flake: {inherit flake;}) inputs;
  in {
    channel.enable = false;
    # required for nix-shell -p to work
    inherit nixPath;
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nix; # for lix: pkgs.lixPackageSets.latest.lix;
    # to use shorter IDs instead of lengthy address
    registry =
      registry
      // {
        n = registry.nixpkgs;
        master = {
          # the flake reference: 'nixpkgs-master'
          from = {
            type = "indirect";
            id = "nixpkgs-master";
          };
          # the flake reference from: github:NixOS/nixpkgs
          to = {
            type = "github";
            owner = "NixOS";
            repo = "nixpkgs";
          };
        };
      };
    settings = {
      auto-optimise-store = true; # Optimise symlinks
      # re-evaluate on every rebuild instead of "cached failure of attribute" error
      # eval-cache = false;
      flake-registry = ""; # don't use the global flake registry, define everything explicitly
      # required to be set, for some reason nix.nixPath does not write to nix.conf
      nix-path = nixPath;
      warn-dirty = false;
      # removes ~/.nix-profile and ~/.nix-defexpr
      use-xdg-base-directories = true;

      experimental-features = [
        "nix-command"
        "flakes"
        # NOTE: 'pipe-operators' in nix but 'pipe-operator' in lix
        # https://discourse.nixos.org/t/lix-mismatch-in-feature-name-compared-to-nix/59879
        "pipe-operators"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://niri.cachix.org"
      ];
      # allow building and pushing of laptop config from desktop
      trusted-users = [user];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
    };
  };

  system = {
    # use nixos-rebuild-ng to rebuild the system
    rebuild.enableNg = true;

    # better nixos generation label
    # https://reddit.com/r/NixOS/comments/16t2njf/small_trick_for_people_using_nixos_with_flakes/k2d0sxx/
    nixos.label = concatStringsSep "-" (
      (sort (x: y: x < y) config.system.nixos.tags)
      ++ ["${config.system.nixos.version}.${self.sourceInfo.shortRev or "dirty"}"]
    );
  };

  # enable man-db cache for fish to be able to find manpages
  # https://discourse.nixos.org/t/fish-shell-and-manual-page-completion-nixos-home-manager/15661
  documentation.man.generateCaches = true;

  hm.custom.persist = {
    home = {
      cache.directories = [
        ".cache/nix"
        ".cache/nixpkgs-review"
      ];
    };
  };
}
