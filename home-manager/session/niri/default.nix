{
  lib,
  config,
  self,
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
      packages = with pkgs; [
        # wallpaper
        swww

        # clipboard history
        cliphist
        wl-clipboard

        # screencast
        wl-screenrec
        procps
      ]
      ++ (
        with self.packages.${pkgs.system}; [
          niricast
        ]
      );

      # hyprlock scripts
      file.".config/niri/scripts" = {
        source = ./scripts;
      };
    };
  };
}
