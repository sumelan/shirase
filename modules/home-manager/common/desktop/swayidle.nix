{
  inputs,
  lib,
  config,
  pkgs,
  isLaptop,
  ...
}: let
  inherit
    (lib)
    concatStringsSep
    getExe
    optional
    ;
  niriPkg = config.programs.niri.package;
  noctaliaPkgs = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  lockCmd = "${getExe noctaliaPkgs} ipc call lockScreen lock";
in {
  services.swayidle = {
    enable = true;
    extraArgs = ["-w"];
    events = [
      {
        event = "before-sleep";
        command = concatStringsSep "; " [
          lockCmd
          "${pkgs.playerctl}/bin/playerctl pause"
        ];
      }
      {
        event = "after-resume";
        command = "${getExe niriPkg} msg action power-on-monitors";
      }
      {
        event = "lock";
        command = lockCmd;
      }
      {
        event = "unlock";
        command = "";
      }
    ];

    timeouts =
      [
        {
          timeout = 60 * 10;
          command = lockCmd;
        }
        {
          timeout = 60 * 15;
          command = "${getExe niriPkg} msg action power-off-monitors";
          resumeCommand = "${getExe niriPkg} msg action power-on-monitors";
        }
      ]
      ++ optional isLaptop {
        timeout = 60 * 20;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      };
  };
}
