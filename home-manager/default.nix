{
  lib,
  pkgs,
  user,
  ...
}: let
  inherit
    (lib)
    genAttrs
    ;
in {
  imports = [
    ./common
    ./optional
    ./hardware.nix
    ./impermanence.nix
    ./input.nix
    ./style.nix
  ];

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

    packages = with pkgs; [
      curl
      gzip
      microfetch
      trash-cli
      xdg-utils
    ];
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    mimeApps.enable = true;

    # hide unnecessary desktopItems
    desktopEntries = let
      hideList = [
        "fcitx5-configtool"
        "kcm_fcitx5"
        "org.fcitx.Fcitx5"
        "org.fcitx.fcitx5-migrator"
        "kbd-layout-viewer5"
        "fish"
        "nm-connection-editor"
      ];
    in
      # generate an attribute set by mapping a function over a list of attribute names.
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
