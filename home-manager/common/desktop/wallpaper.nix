{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  swww-git = inputs.swww.packages.${pkgs.system}.swww;

  wallImg = ../../../hosts/wallpaper.jpg;

  blurImg =
    img:
    pkgs.runCommand "wallpaper-blurred.jpg" { } ''
      ${lib.getExe' pkgs.imagemagick "magick"} ${img} -blur 0x30 $out
    '';
in
{
  home = {
    file = {
      ".wallpaper.jpg".source = wallImg;
      ".wallpaper-blurred.jpg".source = blurImg wallImg;
    };
    packages = [ swww-git ];
  };

  systemd.user.services = {
    "swww-workspace" = {
      Install = {
        WantedBy = [ config.wayland.systemd.target ];
      };
      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "swww-daemon for workspace";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
      };
      Service = {
        ExecStart = "${lib.getExe' swww-git "swww-daemon"} --namespace workspace";
        Restart = "always";
        RestartSec = 10;
      };
    };

    "swww-overview" = {
      Install = {
        WantedBy = [ config.wayland.systemd.target ];
      };
      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "swww-daemon for overview";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
      };
      Service = {
        ExecStart = "${lib.getExe' swww-git "swww-daemon"} --namespace overview";
        Restart = "always";
        RestartSec = 10;
      };
    };
    "wallpaper" = {
      Install = {
        WantedBy = [
          "swww-workspace.service"
          "swww-overview.service"
        ];
      };
      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "Set walpaper with swww";
        After = [
          "swww-workspace.service"
          "swww-overview.service"
        ];
        Requires = [
          "swww-workspace.service"
          "swww-overview.service"
        ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = pkgs.writers.writeFish "wallpaer-startup" ''
          ${lib.getExe' swww-git "swww"} img .wallpaper.jpg --namespace workspace
          ${lib.getExe' swww-git "swww"} img .wallpaper-blurred.jpg --namespace overview
        '';
      };
    };
  };
}
