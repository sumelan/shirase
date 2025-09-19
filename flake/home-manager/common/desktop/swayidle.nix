{
  lib,
  config,
  pkgs,
  isDesktop,
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
    swayidle.enable = mkEnableOption "Swayilde" // {default = true;};
  };

  config = mkIf config.custom.swayidle.enable {
    services.swayidle = {
      enable = true;
      extraArgs = ["-w"];
      events = let
        lockCmd = pkgs.writeShellScript "dms-lock" ''
          if [ "$(${getExe cfg.package} -c dms ipc call lock isLocked)" = 'false' ]; then
            ${getExe cfg.package} -c dms ipc call lock lock
          fi
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
          command = builtins.toString lockCmd;
        }
        {
          event = "unlock";
          command = "";
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
        (mkIf (!isDesktop) {
          timeout = 60 * 20;
          command = "${getExe' pkgs.systemd "systemctl"} suspend";
        })
      ];
    };
  };
}
