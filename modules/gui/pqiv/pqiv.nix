{
  lib,
  self,
  ...
}: let
  inherit (builtins) listToAttrs;
  inherit (lib) mkOption mkDefault getExe hiPrio;
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
in {
  flake.wrappers.pqiv = {
    config,
    wlib,
    ...
  }: let
    inherit (wlib.types) file;
    pqivConf = import ./_config.nix {inherit config;};
  in {
    imports = [wlib.modules.default];

    options =
      pqivOptions
      // {
        pqivrc = mkOption {
          type = file config.pkgs;
          default.path = pqivConf;
          visible = false;
        };
      };

    config.package = mkDefault config.pkgs.pqiv;
    config.env.PQIVRC_PATH = "${config.pqivrc.path}/pqivrc";
  };

  # expose generic pqiv package without local paths
  perSystem = {pkgs, ...}: {
    packages.pqiv = (self.wrappers.pqiv.apply {inherit pkgs;}).wrapper;
  };

  flake.modules.nixos.gui = {pkgs, ...}: let
    pqiv-desktop-entry = pkgs.makeDesktopItem {
      name = "pqiv";
      desktopName = "Pqiv";
      genericName = "Image Viewer";
      noDisplay = true;
      icon = "image-x-png";
      exec = "${getExe pkgs.pqiv} %F";
    };
  in {
    nixpkgs.overlays = [
      (_: prev: {
        pqiv =
          (self.wrappers.pqiv.apply {
            pkgs = prev;
          }).wrapper;
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
      };
    };

    custom.programs.print-config = {
      pqiv =
        # sh
        ''moor "${pkgs.pqiv.configuration.env.PQIVRC_PATH.data}"'';
    };
  };
}
