{
  config,
  inputs,
  lib,
  pkgs,
  self,
  user,
  ...
}:
{
  # execute shebangs that assume hardcoded shell paths
  services.envfs.enable = true;
  system = {
    # envfs sets usrbinenv activation script to "" with mkForce
    activationScripts.usrbinenv = lib.mkOverride (50 - 1) ''
      if [ ! -d "/usr/bin" ]; then
        mkdir -p /usr/bin
        chmod 0755 /usr/bin
      fi
    '';

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
      nixfmt-rfc-style
    ];
  };

  systemd.tmpfiles.rules = [
    # cleanup nixpkgs-review cache on boot
    "D! ${config.hm.xdg.cacheHome}/nixpkgs-review 1755 ${user} users 5d"
    # cleanup channels so nix stops complaining
    "D! /nix/var/nix/profiles/per-user/root 1755 root root 1d"
  ];

  # never going to read html docs locally
  documentation = {
    enable = true;
    doc.enable = true;
    man.enable = true;
    dev.enable = false;
  };

  nix =
    let
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
    in
    {
      channel.enable = false;
      # required for nix-shell -p to work
      inherit nixPath;
      gc = {
        # Automatic garbage collection
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
      package = pkgs.lixPackageSets.latest.lix;
      registry = (lib.mapAttrs (_: flake: { inherit flake; }) inputs) // {
        master = {
          from = {
            type = "indirect";
            id = "nixpkgs-master";
          };
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

        # use flakes
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operator"
        ];
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://niri.cachix.org"
        ];
        # allow building and pushing of laptop config from desktop
        trusted-users = [ user ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
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
    nixos.label = lib.concatStringsSep "-" (
      (lib.sort (x: y: x < y) config.system.nixos.tags)
      ++ [ "${config.system.nixos.version}.${self.sourceInfo.shortRev or "dirty"}" ]
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
