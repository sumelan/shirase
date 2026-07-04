{
  lib,
  self,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib) sort concatStringsSep;
in {
  flake.modules.nixos.core = {
    config,
    pkgs,
    user,
    dotfile,
    ...
  }: {
    # nix lang / nixpkgs
    environment.systemPackages = attrValues {
      inherit
        (pkgs)
        nix-init
        nix-output-monitor
        nix-tree
        nix-update
        nixd
        nixfmt
        nixpkgs-review
        ;
    };

    programs = {
      # wrapping comma with nix-index-database and put it in the PATH
      nix-index-database.comma.enable = true;

      # run unpatched binaries on nixos
      nix-ld.enable = true;

      nh = {
        enable = true;
        clean.extraArgs = "--keep 5";
        flake = dotfile;
      };
    };

    nix = {
      # disable channel because i use flake's input as source
      # also make flake registry and nix path match flake input
      # without doing above, `nix run nixpkgs#fastfetch` would come from the channel and not your flake
      channel.enable = false;

      # need for `nix-shell -p` to work
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") {nixpkgs = "";};

      gc = {
        # Automatic garbage collection
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };

      # `pkgs.nixVersions.latest` or `pkgs.lixPackageSets.latest.lix`
      package = pkgs.nixVersions.latest;

      # Periodically optimise via hardlinking store files
      optimise.automatic = true;

      settings = {
        # re-evaluate on every rebuild instead of "cached failure of attribute" error
        # eval-cache = false;

        # don't use the global flake registry, define everything explicitly
        flake-registry = "";

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
          "https://niri-nix.cachix.org"
        ];

        extra-substituters = ["https://noctalia.cachix.org"];
        extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];

        trusted-users = [user];

        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0="
        ];
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
        cache.enable = true;
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
      cache.home.directories = [
        ".cache/nix-index"
        ".cache/nix"
      ];
    };
  };
}
