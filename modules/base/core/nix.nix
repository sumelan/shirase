{
  inputs,
  lib,
  ...
}: let
  inherit (builtins) attrValues readFile;
  inherit
    (lib)
    mkOverride
    mapAttrsToList
    mapAttrs
    sort
    concatStringsSep
    ;
in {
  flake.modules = {
    nixos.default = {
      config,
      pkgs,
      user,
      ...
    }: let
      inherit (inputs) self;
    in {
      # execute shebangs that assume hardcoded shell paths
      services.envfs.enable = true;
      system = {
        # envfs sets usrbinenv activation script to '''' with mkOverride
        activationScripts.usrbinenv =
          mkOverride (50 - 1)
          # sh
          ''
            if [ ! -d "/usr/bin" ]; then
              mkdir -p /usr/bin
              chmod 0755 /usr/bin
            fi
          '';
      };
      # make a symlink of flake within the generation
      # (e.g. /run/current-system/src)
      system.systemBuilderCommands = "ln -s ${self.sourceInfo.outPath} $out/src";
      # nix lang / nixpkgs
      environment.systemPackages = attrValues {
        inherit (pkgs) nix-init nix-update;
      };

      nix = let
        nixPath = mapAttrsToList (name: _: "${name}=flake:${name}") inputs;
        registry = mapAttrs (_: flake: {inherit flake;}) inputs;
      in {
        # disable channel because i use flake's input as source
        # also make flake registry and nix path match flake input
        # without doing above, `nix run nixpkgs#fastfetch` would come from the channel and not your flake
        channel.enable = false;

        # required for nix-shell -p to work
        inherit nixPath;

        # to use shorter IDs instead of lengthy address
        registry =
          registry
          // {
            n = registry.nixpkgs;
            master = {
              # the flake reference: `nixpkgs-master`
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

        # lix: `pkgs.lixPackageSets.latest.lix`
        package = pkgs.nixVersions.latest;

        # Automatic garbage collection
        gc = {
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 7d";
        };

        settings = {
          # Optimise symlinks
          auto-optimise-store = true;

          # re-evaluate on every rebuild instead of "cached failure of attribute" error
          # eval-cache = false;

          # don't use the global flake registry, define everything explicitly
          flake-registry = "";

          # required to be set
          # for some reason nix.nixPath does not write to nix.conf
          nix-path = nixPath;

          warn-dirty = false;

          # removes ~/.nix-profile and ~/.nix-defexpr
          use-xdg-base-directories = true;

          # use flakes
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          substituters = [
            "https://nix-community.cachix.org"
          ];
          trusted-users = [user];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        };
      };

      system = {
        # better nixos generation label
        # https://reddit.com/r/NixOS/comments/16t2njf/small_trick_for_people_using_nixos_with_flakes/k2d0sxx/
        nixos.label = concatStringsSep "-" (
          (sort (x: y: x < y) config.system.nixos.tags)
          ++ ["${config.system.nixos.version}.${self.sourceInfo.shortRev or "dirty"}"]
        );
      };

      programs = {
        # files database for nixpkgs
        nix-index.enable = true;
        # run unpatched binaries on nixos
        nix-ld.enable = true;
      };

      systemd.tmpfiles.settings = {
        # cleanup nixpkgs-review cache on boot
        "10-cleanupReviewCache" = {
          "/home/${user}/.cache/nixpkgs-review" = {
            "D!" = {
              group = "users";
              mode = "1775";
              inherit user;
              age = "5d";
            };
          };
        };
        # cleanup channels so nix stops complaining
        "10-cleanupChannel" = {
          "/nix/var/nix/profiles/per-user/root" = {
            "D!" = {
              group = "root";
              mode = "1775";
              user = "root";
              age = "1d";
            };
          };
        };
      };
      # documents
      # never going to read html docs locally
      documentation = {
        enable = true;
        doc.enable = true;
        man = {
          enable = true;
          # enable man-db cache for fish to be able to find manpages
          # https://discourse.nixos.org/t/fish-shell-and-manual-page-completion-nixos-home-manager/15661
          generateCaches = true;
        };
        dev.enable = false;
      };
    };
    homeManager.default = {
      pkgs,
      user,
      ...
    }: {
      home.packages = attrValues {
        inherit
          (pkgs)
          comma # Runs software without installing it. usage: `, cowsay neato`
          nix-output-monitor
          nix-tree
          nix-search-tv
          nixd
          nvd
          nvfetcher
          ;
        nixpkgs-reviewPackage = pkgs.nixpkgs-review.override {withNom = true;};
        nsPackage = pkgs.writeShellApplication {
          name = "ns";
          runtimeInputs = [
            pkgs.fzf
            pkgs.nix-search-tv
          ];
          checkPhase = ""; # ignore checks since i didn't write this
          text = readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
        };
      };

      programs = {
        nix-index.enable = true;
        nh = {
          enable = true;
          clean.extraArgs = "--keep 5";
          flake = "/persist/home/${user}/Projects/shirase";
        };
      };

      xdg.desktopEntries = {
        nix-search-tv = {
          name = "Nix Search TV";
          genericName = "Fuzzy search for Nix packages";
          icon = "nix-snowflake";
          terminal = true;
          exec = "ns";
        };
      };

      custom.cache.home.directories = [
        ".cache/nix-index"
        ".cache/nix-search-tv"
        ".cache/nix"
        ".cache/nixpkgs-review"
      ];
    };
  };
}
