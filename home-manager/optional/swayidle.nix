{
  lib,
  config,
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
          command = "qs -c dms ipc call lock lock";
        }
        {
          event = "after-resume";
          command = "niri msg action power-on-monitors";
        }
        {
          event = "lock";
          command = "qs -c dms ipc call lock lock";
        }
        {
          event = "unlock";
          command = "qs -c dms ipc call lock lock";
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
          command = "qs -c dms ipc call lock lock";
        }
        {
          timeout = 60 * 15;
          command = "niri msg action power-off-monitors";
          resumeCommand = "niri msg action power-on-monitors";
        }
        (lib.mkIf (!isServer) {
          timeout = 60 * 20;
          command = "systemctl suspend";
        })
      ];
    };
  };
}
