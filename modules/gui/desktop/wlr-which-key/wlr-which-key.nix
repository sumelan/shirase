{
  lib,
  self,
  ...
}: let
  inherit (lib) concatStringsSep;

  baseWlrConf = import ./_config.nix {};
in {
  flake.wrappers.wlr-which-key = {wlib, ...}: {
    imports = [wlib.wrapperModules.wlr-which-key];

    initialKeys = "";
    settings = baseWlrConf;
  };

  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: {
    nixpkgs.overlays = [
      (_: prev: {
        wlr-which-key = self.wrappers.wlr-which-key.wrap {
          pkgs = prev;
          # add extra settings
          settings = {
            font = concatStringsSep " " [
              config.custom.fonts.monospace
              "Bold"
              "Italic"
              "14"
            ];
          };
        };
      })
    ];

    hj.packages = [
      pkgs.wlr-which-key # overlay-ed above
    ];

    # print-config is broken due to yaml format
  };
}
