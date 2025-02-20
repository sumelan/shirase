{
  lib,
  config,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./editor
    ./gui
    ./session
    ./tui
    ./hardware.nix
    ./impermanence.nix # only contains options
    ./style.nix
  ];

  options.custom = with lib; {
    autologinCommand = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to run after autologin";
    };
    fonts = {
      regular = mkOption {
        type = types.str;
        default = "Ubuntu Nerd Font";
        description = "The font to use for regular text";
      };
      monospace = mkOption {
        type = types.str;
        default = "JetBrainsMono Nerd Font";
        description = "The font to use for monospace text";
      };
      packages = mkOption {
        type = types.listOf types.package;
        description = "The packages to install for the fonts";
      };
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

    custom = {
      fonts.packages = with pkgs; [
        # noto-fonts-cjk is already installed in system-wide
        nerd-fonts.jetbrains-mono
      ];

      persist = {
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
  };
}
