{
  config,
  dots,
  host,
  inputs,
  lib,
  pkgs,
  self,
  user,
  ...
}:
{
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

  nix =
    let
      nixPath = [
        "nixpkgs=flake:nixpkgs"
        # "/nix/var/nix/profiles/per-user/root/channels"
      ];
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
      package = pkgs.nixVersions.latest;
      registry = {
        n.flake = inputs.nixpkgs-stable;
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
        stable.flake = inputs.nixpkgs-stable;
      };
      settings = {
        auto-optimise-store = true; # Optimise symlinks
        # re-evaluate on every rebuild instead of "cached failure of attribute" error
        # eval-cache = false;
        # required to be set, for some reason nix.nixPath does not write to nix.conf
        nix-path = nixPath;
        warn-dirty = false;
        # removes ~/.nix-profile and ~/.nix-defexpr
        use-xdg-base-directories = true;

        # use flakes
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
          # "repl-flake"
        ];
        substituters = [
          "https://nix-community.cachix.org"
        ];
        # allow building and pushing of laptop config from desktop
        trusted-users = [ user ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      # // lib.optionalAttrs (config.nix.package.pname == "lix") {
      #   repl-overlays = [ ./repl-overlays.nix ];
      # };
    };

  # better nixos generation label
  # https://reddit.com/r/NixOS/comments/16t2njf/small_trick_for_people_using_nixos_with_flakes/k2d0sxx/
  system.nixos.label = lib.concatStringsSep "-" (
    (lib.sort (x: y: x < y) config.system.nixos.tags)
    ++ [ "${config.system.nixos.version}.${self.sourceInfo.shortRev or "dirty"}" ]
  );

  # add nixos-option workaround for flakes
  # https://github.com/NixOS/nixpkgs/issues/97855#issuecomment-1075818028
  nixpkgs.overlays = [
    (_: prev: {
      nixos-option =
        let
          flake-compat = prev.fetchFromGitHub {
            owner = "edolstra";
            repo = "flake-compat";
            rev = "12c64ca55c1014cdc1b16ed5a804aa8576601ff2";
            hash = "sha256-hY8g6H2KFL8ownSiFeMOjwPC8P0ueXpCVEbxgda3pko=";
          };
          prefix = ''(import ${flake-compat} { src = ${dots}; }).defaultNix.nixosConfigurations.${host}'';
        in
        prev.runCommandNoCC "nixos-option" { buildInputs = [ prev.makeWrapper ]; } ''
          makeWrapper ${lib.getExe prev.nixos-option} $out/bin/nixos-option \
            --add-flags --config_expr \
            --add-flags "\"${prefix}.config\"" \
            --add-flags --options_expr \
            --add-flags "\"${prefix}.options\""
        '';
    })
  ];

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
