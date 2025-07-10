{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  swww-git = inputs.swww.packages.${pkgs.system}.swww;
  wallImg = ../../../../hosts/wallpaper.jpg;
in
lib.mkIf config.custom.maomao.enable {
  home = {
    file = {
      ".wallpaper.jpg".source = wallImg;
    };
    packages = [ swww-git ];
  };

  systemd.user.services = {
    "swww-daemon" = {
      Install = {
        WantedBy = [ config.wayland.systemd.target ];
      };
      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "swww-daemon for background";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
      };
      Service = {
        ExecStart = "${lib.getExe' swww-git "swww-daemon"} --namespace background";
        Restart = "always";
        RestartSec = 10;
      };
    };

    "wallpaper" = {
      Install = {
        WantedBy = [
          "swww-daemon.service"
        ];
      };
      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "Set walpaper with swww";
        After = [
          "swww-daemon.service"
        ];
        Requires = [
          "swww-daemon.service"
        ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = pkgs.writers.writeFish "wallpaer-startup" ''
          ${lib.getExe' swww-git "swww"} img .wallpaper.jpg --namespace background
        '';
      };
    };
  };
}
