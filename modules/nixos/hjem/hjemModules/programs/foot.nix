{lib, ...}: let
  inherit (lib) mkPackageOption mkEnableOption;
in {
  flake.custom.hjemModules.foot = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.programs.foot;
  in {
    options.rum = {
      programs.foot = {
        enable = mkEnableOption "Fast, lightweight and minimalistic Wayland terminal emulator";

        package = mkPackageOption pkgs "foot" {};

        server = {
          enable = mkEnableOption "Foot terminal server";
        };
      };
    };

    config = lib.mkIf cfg.enable {
      packages = [cfg.package];

      systemd.services.foot-server = lib.mkIf cfg.server.enable {
        description = "Foot terminal server mode";
        documentation = ["man:foot(1)"];
        path = [
          "/run/current-system/sw"
          "/etc/profiles/per-user/${config.user}"
        ];
        requires = ["%N.socket"];
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];
        environment = {
          DISPLAY = "WAYLAND_DISPLAY";
        };
        wantedBy = ["graphical-session.target"];

        serviceConfig = {
          ExecStart = "${lib.getExe cfg.package} --server=3";
          Restart = "on-failure";
          OOMPolicy = "continue";
        };
      };
    };
  };
}
