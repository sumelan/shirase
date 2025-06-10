{
  lib,
  config,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./common
    ./optional
    ./style.nix
  ];

  options.custom = with lib; {
    autologinCommand = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to run after autologin";
    };
    symlinks = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Symlinks to create in the format { dest = src;}";
    };
  };

  config = {
    home = {
      username = user;
      homeDirectory = "/home/${user}";
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
      # hide unnecessary desktopItems
      desktopEntries =
        let
          hideList = [
            "fcitx5-configtool"
            "kcm_fcitx5"
            "org.fcitx.Fcitx5"
            "org.fcitx.fcitx5-migrator"
            "nixos-manual"
            "fish"
            "yazi"
          ];
        in
        lib.attrsets.genAttrs hideList (name': {
          name = name';
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
