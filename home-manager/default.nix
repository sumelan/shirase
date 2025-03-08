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

      packages =
        with pkgs;
        [
          curl
          gzip
          trash-cli
          xdg-utils
        ]
        ++ (lib.optional config.custom.helix.enable helix);

      activation = {
        reload-waybar =
          lib.hm.dag.entryAfter [ "niri-transition" ]
            # bash
            ''
              run --quiet ${pkgs.systemd}/bin/systemctl --user restart waybar.service
            '';
      };
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
