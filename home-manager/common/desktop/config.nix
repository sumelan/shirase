{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) genAttrs;
in {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      brightnessctl
      playerctl
      wl-clipboard
      ;
  };

  # hide unnecessary desktopItems
  xdg.desktopEntries = let
    hideList = [
      "kcm_fcitx5"
      "org.fcitx.Fcitx5"
      "org.fcitx.fcitx5-migrator"
      "kbd-layout-viewer5"
      "fish"
      "nm-connection-editor"
      "blueman-adapters"
    ];
  in
    genAttrs hideList (name: {
      inherit name;
      noDisplay = true;
    });
}
