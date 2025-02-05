{
  lib,
  pkgs,
  config,
  isNixOS,
  user,
  ...
}:
{
  imports = [
    ./editor
    ./gui
    ./niri
    ./shell
    ./hardware.nix
    ./impermanence.nix # only contains options
  ];

  options.custom = with lib; {
    fonts = {
      regular = mkOption {
        type = types.str;
        default = "Geist Regular";
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
  };

  config = {
    fonts.fontconfig.enable = true;

    home = {
      username = user;
      homeDirectory = "/home/${user}";
      # do not change this value
      stateVersion = "24.05";

      sessionVariables = {
        __IS_NIXOS = if isNixOS then "1" else "0";
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
        ++ (lib.optional config.custom.helix.enable helix)
        # home-manager executable only on nixos
        ++ (lib.optional isNixOS home-manager)
        # handle fonts
        ++ (lib.optionals (!isNixOS) config.custom.fonts.packages);
    };

    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;

    xdg = {
      enable = true;
      userDirs.enable = true;
      mimeApps.enable = true;
    };

    custom = {
      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji
        nerd-fonts.jetbrains-mono
      ];

      persist = {
        home.directories = [
          "Desktop"
          "Documents"
          "Pictures"
        ];
      };
    };
  };
}
