{
  lib,
  pkgs,
  config,
  user,
  ...
}:
{
  imports = [
    ./common
    ./optional
    ./hardware.nix
    ./impermanence.nix
    ./style.nix
  ];

  options.custom = with lib; {
    symlinks = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Symlinks to create";
    };
  };

  config = {
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
        trash-cli
        xdg-utils
      ];
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    systemd.user.startServices = "sd-switch"; # Nicely reload system units when changing configs

    # create symlinks
    systemd.user.tmpfiles.rules =
      let
        normalizeHome = p: if (lib.hasPrefix "/home" p) then p else "${config.home.homeDirectory}/${p}";
      in
      lib.mapAttrsToList (dest: src: "L+ ${normalizeHome dest} - - - - ${src}") config.custom.symlinks;

    xdg = {
      enable = true;
      userDirs.enable = true;
      mimeApps.enable = true;

      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
        config = {
          niri."org.freedesktop.impl.portal.FileChooser" = "gtk";
          niri.default = "gnome";
          common.default = "gnome";
          obs.default = "gnome";
        };
      };

      # hide unnecessary desktopItems
      desktopEntries =
        let
          hideList = [
            "fcitx5-configtool"
            "kcm_fcitx5"
            "org.fcitx.Fcitx5"
            "org.fcitx.fcitx5-migrator"
            "kbd-layout-viewer5"
            "nixos-manual"
            "fish"
            "yazi"
            "nm-connection-editor"
          ];
        in
        # generate an attribute set by mapping a function over a list of attribute names.
        lib.genAttrs hideList (name: {
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
  };
}
