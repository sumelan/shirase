{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    eww = {
      enable = mkEnableOption "eww" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.custom.eww.enable {
    programs.eww = {
      enable = true;
      package = pkgs.eww;
      enableBashIntegration = true;
      enableFishIntegration = true;
      configDir = ./components;
    };

    programs.nushell = {
      enable = true;
    };
    home.packages = with pkgs; [
      mailutils
      slurp
      socat
      wf-recorder
    ];

    programs.niri.settings = {
      spawn-at-startup = [
        {
          command = [
            "sh"
            "-c"
            "eww daemon --config ~/.config/eww/sidebar && eww open --config ~/.config/eww/sidebar sidebar"
          ];
        }
        {
          command = [
            "sh"
            "-c"
            "eww daemon --config ~/.config/eww/statusbar && eww open --config ~/.config/eww/statusbar statusbar --arg stacking=overlay"
          ];
        }
      ];
    };
  };
}
