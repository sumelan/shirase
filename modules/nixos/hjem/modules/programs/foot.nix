{lib, ...}: let
  inherit (lib) mkOption mkPackageOption mkEnableOption;
  inherit (lib.types) listOf package;
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
          path = mkOption {
            type = listOf package;
            default = [];
            description = ''
              Packages added to the service's PATH environment variable.
              Both the `bin` and `sbin` subdirectories of each package are added.
            '';
          };
        };
      };
    };

    config = lib.mkIf cfg.enable {
      packages = [cfg.package];

      systemd.services.foot-server = lib.mkIf cfg.server.enable {
        description = "Foot terminal server mode";
        documentation = ["man:foot(1)"];
        path = cfg.server.path;
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
