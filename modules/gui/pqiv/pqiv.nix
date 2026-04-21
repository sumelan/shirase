{lib, ...}: let
  inherit (builtins) listToAttrs;
  inherit (lib) mkOption mkDefault hiPrio;
  inherit (lib.types) lines;

  pqivOptions = {
    options = mkOption {
      type = lines;
      default = "";
      description = "Contents under [options] section of pqiv config file";
    };

    actions = mkOption {
      type = lines;
      default = "";
      description = "Contents under [actions] section of pqiv config file";
    };

    keybindings = mkOption {
      type = lines;
      default = "";
      description = "Contents under [keybindings] section of pqiv config file";
    };

    extraConfig = mkOption {
      type = lines;
      default = "";
      description = "Extra config to add to pqiv config file";
    };
  };
  basePqivConf = config: import ./_config.nix {inherit config;};
in {
  flake.wrappers.pqiv = {
    config,
    wlib,
    ...
  }: {
    imports = [wlib.modules.default];

    options =
      pqivOptions
      // {
        pqivrc = mkOption {
          type = wlib.types.file config.pkgs;
          default.path = basePqivConf config;
          visible = false;
        };
      };

    config.package = mkDefault config.pkgs.pqiv;
    config.env.PQIVRC_PATH = "${config.pqivrc.path}/pqivrc";
  };

  flake.modules.nixos.gui = {pkgs, ...}: let
    pqiv-desktop-entry = pkgs.makeDesktopItem {
      name = "pqiv";
      desktopName = "Pqiv";
      genericName = "Image Viewer";
      noDisplay = true;
      icon = "image-x-png";
      exec = "pqiv %F";
    };
  in {
    nixpkgs.overlays = [
      (_: _prev: {
        inherit (pkgs.custom) pqiv;
      })
    ];

    hj = {
      packages = [
        pkgs.pqiv # overlay-ed above
        (hiPrio pqiv-desktop-entry)
      ];

      xdg.mime-apps = let
        value = "pqiv.desktop";
        associations = listToAttrs (map (name: {
            inherit name value;
          }) [
            "image/jpeg"
            "image/gif"
            "image/webp"
            "image/png"
          ]);
      in {
        default-applications = associations;
        added-associations = associations;
      };
    };

    custom.programs.print-config = {
      pqiv =
        # sh
        ''moor "${pkgs.pqiv.configuration.env.PQIVRC_PATH.data}"'';
    };
  };
}
