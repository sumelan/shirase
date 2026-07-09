{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
  inherit (lib) mkPackageOption mkEnableOption;
in {
  flake.custom.hjemModules.ghostty = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.programs.ghostty;
    local = flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    options.rum = {
      programs.ghostty = {
        enable = mkEnableOption "Ghostty";

        package = mkPackageOption pkgs "ghostty" {};

        systemd = {
          enable = mkEnableOption "The ghostty systemd user service";
        };
      };
    };

    config = lib.mkIf cfg.enable {
      packages = [cfg.package];

      systemd.services."app-com.mitchellh.ghostty" = lib.mkIf cfg.systemd.enable {
        description = "Ghostty";
        path = [
          "/run/current-system/sw"
          "/etc/profiles/per-user/${config.user}"
        ];

        requires = ["dbus.socket"];
        after = ["graphical-session.target" "dbus.socket"];
        wantedBy = ["graphical-session.target"];

        serviceConfig = {
          Type = "notify-reload";
          ReloadSignal = "SIGUSR2";
          BusName = "com.mitchellh.ghostty";
          ExecStart = "${lib.getExe cfg.package} --gtk-single-instance=true --initial-window=false";
        };
      };

      rum.dbus.packages = [cfg.package];

      xdg.config.files."ghostty/config" = {
        permissions = "666";
        text = "";
        type = "copy";
      };
    };
  };
}
