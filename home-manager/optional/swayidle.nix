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
      systemdTarget = "sway-session.target";
      extraArgs = ["-w"];
      events = [
        {
          event = "before-sleep";
          command = lib.concatStringsSep "; " [
            "qs -c DankMaterialShell ipc call lock lock"
            "qs -c DankMaterialShell ipc call mpris playPause"
          ];
        }
        {
          event = "after-resume";
          command = "niri msg action power-on-monitors";
        }
        {
          event = "lock";
          command = "qs -c DankMaterialShell ipc call lock lock";
        }
        {
          event = "unlock";
          command = "";
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
          command = "qs -c DankMaterialShell ipc call lock lock";
        }
        {
          timeout = 60 * 15;
          command = "niri msg action power-off-monitors";
          resumeCommand = "niri msg action power-on-monitors";
        }
        (lib.optionalAttrs (!isServer) {
          timeout = 60 * 20;
          command = "systemctl suspend";
        })
      ];
    };
  };
}
