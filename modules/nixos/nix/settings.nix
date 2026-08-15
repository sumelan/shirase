{
  lib,
  self,
  ...
}: let
  inherit (lib) sort concatStringsSep;
in {
  flake.modules.nixos.core = {
    config,
    user,
    dotfile,
    ...
  }: {
    # nix lang / nixpkgs
    environment = {
      variables = {
        TACK_DIR = "${dotfile}/.tack";
      };
    };

    programs = {
      # flake-like toml nix pins, lazily fetched and transformed
      tack = {
        enable = true;
        # tack reading `access-tokens` from nix.conf when comparing forge revisions.
        # off by default: it widens which credentials tack may replay to a forge beyond the ones in the environment
        nixConfTokens = true;
      };

      # wrapping comma with nix-index-database and put it in the PATH
      nix-index-database.comma.enable = true;

      # run unpatched binaries on nixos
      nix-ld.enable = true;

      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--optimise --keep-since 7d";
        };
        flake = dotfile;
      };
    };

    nix = let
      flakes = removeAttrs (import "${self}/.tack") ["" "__functor"];
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakes;
      registry = lib.mapAttrs (_: flake: {inherit flake;}) flakes;
    in {
      # disable channel because i use flake's input as source
      # also make flake registry and nix path match flake input
      # without doing above, `nix run nixpkgs#fastfetch` would come from the channel and not your flake
      channel.enable = false;

      # need for `nix-shell -p` to work
      inherit nixPath;

      registry =
        registry
        // {
          n = registry.nixpkgs;
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
          # for nix flake init
          templates = {
            from = {
              id = "templates";
              type = "indirect";
            };
            to = {
              type = "github";
              owner = "NixOS";
              repo = "templates";
            };
          };
        };

      extraOptions = ''
        !include ${config.sops.secrets.nixAccessTokens.path}
      '';

      settings = {
        warn-dirty = false;

        nix-path = nixPath;

        # re-evaluate on every rebuild instead of "cached failure of attribute" error
        # eval-cache = false;

        # define everything explicitly
        flake-registry = "";

        # removes ~/.nix-profile and ~/.nix-defexpr
        use-xdg-base-directories = true;

        # use flakes
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        substituters = [
          "https://nix-community.cachix.org"
          "https://niri-nix.cachix.org"
        ];

        trusted-users = [user];

        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0="
        ];

        extra-substituters = ["https://noctalia.cachix.org"];

        extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
      };
    };

    # never going to read html docs locally
    documentation = {
      enable = true;
      doc.enable = true;
      man = {
        enable = true;
        # enable man-db cache for fish to be able to find manpages
        # https://discourse.nixos.org/t/fish-shell-and-manual-page-completion-nixos-home-manager/15661
        cache.enable = false;
      };
      dev.enable = false;
    };

    # execute shebangs that assume hardcoded shell paths
    services.envfs.enable = true;

    system = {
      # better nixos generation label
      # https://reddit.com/r/NixOS/comments/16t2njf/small_trick_for_people_using_nixos_with_flakes/k2d0sxx/
      nixos.label = concatStringsSep "-" (
        (sort (x: y: x < y) config.system.nixos.tags)
        ++ ["${config.system.nixos.version}.${self.sourceInfo.shortRev or "dirty"}"]
      );

      # make a symlink of flake within the generation
      # (e.g. /run/current-system/src)
      systemBuilderCommands = "ln -s ${self.sourceInfo.outPath} $out/src";
    };

    systemd.tmpfiles.rules = [
      # cleanup nixpkgs-review cache on boot
      "D! /home/${user}/.cache/nixpkgs-review 1775 ${user} users 5d"
      # cleanup channels so nix stops complaining
      "D! /nix/var/nix/profiles/per-user/root 1775 root root 1d"
    ];

    custom.fileSystem = {
      cache = {
        root.directories = [
          "/var/cache/man/nixos-mandb"
          "/var/cache/man/nixos-manpages"
        ];

        home.directories = [
          ".cache/nix-index"
          ".cache/nix"
        ];
      };
    };
  };
}
