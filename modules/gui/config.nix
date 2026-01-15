{lib, ...}: let
  inherit (lib) genAttrs;
in {
  flake.modules.homeManager.default = {user, ...}: {
    # create directories on boot if not exist
    systemd.user.tmpfiles.rules = [
      "d! %h/Pictures/Wallpapers - ${user} users - -"
      "d! %h/Pictures/Screenshots - ${user} users - -"
      "d! %h/Pictures/Satty - ${user} users - -"
      "d! %h/Videos/OBS-Studio - ${user} users - -"
      "d! %h/Videos/Kooha - ${user} users - -"
    ];

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
