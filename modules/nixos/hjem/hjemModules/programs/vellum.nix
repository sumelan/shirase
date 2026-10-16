{lib, ...}: let
  inherit (lib) mkIf mkOption mkPackageOption mkEnableOption getExe;
in {
  flake.custom.hjemModules.vellum = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.programs.vellum;
    tomlFmt = pkgs.formats.toml {};
    configFile = tomlFmt.generate "vellum-config.toml" cfg.settings;
  in {
    options.rum = {
      programs.vellum = {
        enable = mkEnableOption "Wayland native screen annotation tool";
        package = mkPackageOption pkgs "vellum" {};
        systemd = {
          enable =
            mkEnableOption "Vellum systemd service"
            // {
              default = true;
            };
        };
        settings = mkOption {
          inherit (tomlFmt) type;
          default = {};
          example = {
            default_tool = "arrow";
            remember_last_tool = false;
            default_fill_shapes = true;
            feedback_duration_ms = 250;
            tools.pen.opacity = 0.75;
            palette = [
              "#FF6B6B"
              "#FFD93D"
              "#6BCB77"
              "#4D96FF"
              "#845EC2"
            ];
          };
          description = ''
            Configuration options for vellum.
            NixOS writes system-wide configuration, while Home Manager writes the user's configuration.
            See available options at <https://github.com/greyxp1/vellum#configuration>.
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      packages = [cfg.package];

      xdg.config.files."vellum/config.toml" = {
        source = configFile;
      };

      systemd.services.vellum = {
        description = "Vellum screen annotation overlay";
        after = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        restartTriggers = [configFile];
        serviceConfig = {
          Type = "exec";
          ExecStart = getExe cfg.package;
          Restart = "on-failure";
        };
      };
    };
  };
}
