{lib, ...}: let
  inherit (lib) genAttrs;
in {
  flake.modules.homeManager.default = _: {
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
        "nixos-manual"
      ];
    in
      genAttrs hideList (name: {
        inherit name;
        noDisplay = true;
      });

    custom.persist.home.directories = [
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"
    ];
  };
}
