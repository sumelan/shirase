{
  lib,
  config,
  pkgs,
  isLaptop,
  ...
}: let
  inherit
    (lib)
    mkIf
    concatStringsSep
    getExe
    getExe'
    ;
  niriPkg = config.programs.niri.package;
  dimlandPkg = config.programs.dimland.package;
in {
  services.swayidle = {
    enable = true;
    extraArgs = ["-w"];
    events = [
      {
        event = "before-sleep";
        command = concatStringsSep "; " [
          "${pkgs.systemd}/bin/loginctl lock-session"
          # stop playing
          "${pkgs.playerctl}/bin/playerctl pause"
        ];
      }
      {
        event = "after-resume";
        command = "${getExe niriPkg} msg action power-on-monitors";
      }
      {
        event = "lock";
        # exec gtklock unless already running
        command = "${pkgs.procps}/bin/pidof gtklock || ${pkgs.gtklock}/bin/gtklock -d";
      }
      {
        event = "unlock";
        # kill hyprlock
        command = "${pkgs.procps}/bin/pkill -SIGUSR1 gtklock";
      }
    ];

    timeouts = [
      {
        timeout = 60 * 3;
        command = "${getExe niriPkg} msg action open-overview";
        resumeCommand = "${getExe niriPkg} msg action close-overview";
      }
      {
        timeout = 60 * 5;
        command = "${getExe' dimlandPkg "dimland"} -a 0.6";
        resumeCommand = "${getExe' dimlandPkg "dimland"} stop";
      }
      {
        timeout = 60 * 15;
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        timeout = 60 * 18;
        command = "${getExe niriPkg} msg action power-off-monitors";
        resumeCommand = "${getExe niriPkg} msg action power-on-monitors";
      }
      (mkIf isLaptop {
        timeout = 60 * 20;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      })
    ];
  };
}
