{
  lib,
  config,
  pkgs,
  inputs,
  isDesktop,
  ...
}: let
  cfg = inputs.noctalia-shell.packages.${pkgs.system}.default;

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
      events = [
        {
          event = "before-sleep";
          command = concatStringsSep "; " [
            "${getExe cfg} ipc call lockScreen toggle"
            "${getExe pkgs.playerctl} pause"
          ];
        }
        {
          event = "after-resume";
          command = "${getExe config.programs.niri.package} msg action power-on-monitors";
        }
        {
          event = "lock";
          command = "${getExe cfg} lockScreen toggle";
        }
        {
          event = "unlock";
          command = "";
        }
      ];

      timeouts = [
        (mkIf config.custom.backlight.enable {
          timeout = 60 * 8;
          # set monitor backlight to minimum, avoid 0 on OLED monitor.
          command = "${getExe pkgs.brightnessctl} --save set 5%"; # save previous state in a temporary file
          resumeCommand = "${getExe pkgs.brightnessctl} -r"; # monitor backlight restore
        })
        {
          timeout = 60 * 12;
          command = "${getExe cfg} ipc call lockScreen toggle";
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
