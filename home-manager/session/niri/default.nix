{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./animations.nix
    ./idle.nix
    ./keybinds.nix
    ./lock.nix
    ./rules.nix
    ./settings.nix
  ];

  options.custom = with lib; {
    niri = {
      enable = mkEnableOption "niri" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.custom.niri.enable {
    # start niri-session
    custom.autologinCommand = "niri-session";

    home = {
      packages = [
        # wallpaper
        pkgs.swww

        # clipboard history
        pkgs.cliphist
        pkgs.wl-clipboard

        # screencast
        pkgs.wl-screenrec
        pkgs.custom.niricast
        pkgs.procps
      ];

      # hyprlock scripts
      file.".config/niri/scripts" = {
        source = ./scripts;
      };
    };
  };
}
