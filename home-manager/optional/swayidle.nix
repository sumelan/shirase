{
  lib,
  config,
  pkgs,
  isServer,
  ...
}: let
  cfg = config.programs.quickshell;

  inherit
    (lib)
    mkEnableOption
    mkIf
    concatStringsSep
    getExe
    getExe'
    ;
in {
  options.custom = {
    swayidle.enable = mkEnableOption "Swayilde";
  };

  config = mkIf config.custom.swayidle.enable {
    services.swayidle = {
      enable = true;
      extraArgs = ["-w"];
      events = let
        lockCmd = pkgs.writers.writeFish "dms-lock" ''
          string match 'true' (${getExe cfg.package} -c dms ipc call lock isLocked) \
            || ${getExe cfg.package} -c dms ipc call lock lock
        '';
      in [
        {
          event = "before-sleep";
          command = concatStringsSep "; " [
            "${getExe' pkgs.systemd "loginctl"} lock-session"
            "${getExe pkgs.playerctl} pause"
          ];
        }
        {
          event = "after-resume";
          command = "${getExe config.programs.niri.package} msg action power-on-monitors";
        }
        {
          event = "lock";
          command = "${lockCmd}";
        }
        {
          event = "unlock";
          command = "${getExe' pkgs.systemd "systemctl"} --user restart quickshell.service";
        }
      ];

      timeouts = [
        {
          timeout = 60 * 8;
          command = "${getExe' config.programs.dimland.package "dimland"} -a 0.6";
          resumeCommand = "${getExe' config.programs.dimland.package "dimland"} stop";
        }
        {
          timeout = 60 * 12;
          command = "${getExe' pkgs.systemd "loginctl"} lock-session";
        }
        {
          timeout = 60 * 15;
          command = "${getExe config.programs.niri.package} msg action power-off-monitors";
          resumeCommand = "${getExe config.programs.niri.package} msg action power-on-monitors";
        }
        (mkIf (!isServer) {
          timeout = 60 * 20;
          command = "${getExe' pkgs.systemd "systemctl"} suspend";
        })
      ];
    };
  };
}
