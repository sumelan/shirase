{
  config,
  isLaptop,
  isNixOS,
  lib,
  pkgs,
  ...
}:
let
  lockCmd = "${lib.getExe' pkgs.procps "pidof"} hyprlock || ${lib.getExe config.programs.hyprlock.package}";
in
{
  options.custom = with lib; {
    hyprland = {
      lock = mkEnableOption "locking of host" // {
        default = isLaptop && isNixOS;
      };
    };
  };

  config = lib.mkIf (config.custom.hyprland.enable && config.custom.hyprland.lock) {
    programs.hyprlock.enable = true;

    wayland.windowManager.hyprland.settings = {
      bind = [ "$mod_SHIFT, x, exec, ${lockCmd}" ];

      # handle laptop lid
      bindl = lib.mkIf isLaptop [ ",switch:Lid Switch, exec, ${lockCmd}" ];
    };

    # lock on idle
    services.hypridle = {
      settings = {
        general = {
          lock_cmd = lockCmd;
        };

        listener = [
          {
            timeout = 5 * 60;
            on-timeout = lockCmd;
          }
        ];
      };
    };
  };
}
