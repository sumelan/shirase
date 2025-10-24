{
  lib,
  pkgs,
  user,
  ...
}: let
  inherit (lib) genAttrs;
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home = {
    username = user;
    homeDirectory = "/home/" + user;
    # do not change this value
    stateVersion = "24.05";

    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    packages = builtins.attrValues {
      inherit
        (pkgs)
        brightnessctl
        curl
        gzip
        microfetch
        playerctl
        trash-cli
        wl-clipboard
        xdg-utils
        ;
    };
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    mimeApps.enable = true;

    # hide unnecessary desktopItems
    desktopEntries = let
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
  };

  custom.persist = {
    home.directories = [
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"
    ];
  };
}
