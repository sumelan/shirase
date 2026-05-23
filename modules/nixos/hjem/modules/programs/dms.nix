{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.custom.hjemModules.dms = {
    config,
    pkgs,
    ...
  }: let
    inherit
      (flake.packages.${pkgs.stdenv.hostPlatform.system})
      dms-plugins
      dms-screen-recorder
      dms-display-mirror
      ;
    jsonFmt = pkgs.formats.json {};
    cfg = config.rum.programs.dms;

    pluginDir = "DankMaterialShell/plugins";
  in {
    options.rum = {
      programs.dms = {
        enable =
          lib.mkEnableOption "dankMaterialShell"
          // {
            default = true;
          };

        settings = lib.mkOption {
          inherit (jsonFmt) type;
          default = {};
          description = ''
            DankMaterialShell configuration settings as an attribute set,
            to be written to `~/.config/DankMaterialShell/settings.json`.
          '';
        };

        plugins = {
          enable =
            lib.mkEnableOption "dms plugin"
            // {
              default = true;
            };

          settings = lib.mkOption {
            inherit (jsonFmt) type;
            default = {};
            description = ''
              DnakMaterialShell plugin settings as an attribute set,
              to be written to `~/.config/DankMaterialShell/plugin_settings.json`.
            '';
          };
        };
      };
    };

    config = lib.mkIf cfg.enable {
      xdg.config.files =
        {
          "DankMaterialShell/settings.json" = {
            generator = lib.generators.toJSON {};
            value = cfg.settings;
          };
        }
        // (lib.optionalAttrs cfg.plugins.enable {
          "${pluginDir}/dankBatteryAlerts" = {
            source = "${dms-plugins}/DankBatteryAlerts";
          };
          "${pluginDir}/dankKDEConnect" = {
            source = "${dms-plugins}/DankKDEConnect";
          };
          "${pluginDir}/dankNotepadModule" = {
            source = "${dms-plugins}/DankNotepadModule";
          };
          "${pluginDir}/screenRecorder" = {
            source = dms-screen-recorder;
          };
          "${pluginDir}/displayMirror" = {
            source = dms-display-mirror;
          };

          "DankMaterialShell/plugin_settings.json" = {
            generator = lib.generators.toJSON {};
            value = cfg.plugins.settings;
          };
        });
    };
  };
}
