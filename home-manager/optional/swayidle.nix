{
  lib,
  config,
  pkgs,
  isServer,
  ...
}: {
  options.custom = {
    swayidle.enable = lib.mkEnableOption "Swayilde";
  };

  config = lib.mkIf config.custom.swayidle.enable {
    services.swayidle = {
      enable = true;
      extraArgs = ["-w"];
      events = [
        {
          event = "before-sleep";
          command = "${lib.getExe' config.programs.quickshell.package "qs"} ipc call lockScreen toggle";
        }
        {
          event = "after-resume";
          command = "${lib.getExe config.programs.niri.package} msg action power-on-monitors";
        }
        {
          event = "lock";
          command = "${lib.getExe' config.programs.quickshell.package "qs"} ipc call lockScreen toggle";
        }
        {
          event = "unlock";
          command = "${lib.getExe' config.programs.quickshell.package "qs"} ipc call lockScreen toggle";
        }
      ];
      timeouts = [
        {
          timeout = 60 * 8;
          command = "${lib.getExe' config.programs.dimland.package "dimland"} -a 0.6";
          resumeCommand = "${lib.getExe' config.programs.dimland.package "dimland"} stop";
        }
        {
          timeout = 60 * 12;
          command = "${lib.getExe' config.programs.quickshell.package "qs"} ipc call lockScreen toggle";
        }
        {
          timeout = 60 * 15;
          command = "${lib.getExe config.programs.niri.package} msg action power-off-monitors";
          resumeCommand = "${lib.getExe config.programs.niri.package} msg action power-on-monitors";
        }
        (lib.mkIf (!isServer) {
          timeout = 60 * 20;
          command = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
        })
      ];
    };
  };
}
