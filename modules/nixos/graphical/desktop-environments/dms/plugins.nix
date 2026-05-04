{
  config,
  lib,
  ...
}: let
  inherit (lib.generators) toJSON;
in {
  flake.modules.nixos.gui = {pkgs, ...}: let
    inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) dms-plugins dms-screen-recorder dms-display-mirror;

    pluginDir = "DankMaterialShell/plugins";
    official = dms-plugins;
    recorder = dms-screen-recorder;
    mirror = dms-display-mirror;
  in {
    hj = {
      packages = [
        # plugin dependencies
        pkgs.gpu-screen-recorder
        pkgs.wl-mirror
      ];

      xdg.config.files = {
        "${pluginDir}/dankBatteryAlerts" = {
          source = "${official}/DankBatteryAlerts";
        };
        "${pluginDir}/dankKDEConnect" = {
          source = "${official}/DankKDEConnect";
        };
        "${pluginDir}/dankNotepadModule" = {
          source = "${official}/DankNotepadModule";
        };
        "${pluginDir}/screenRecorder" = {
          source = recorder;
        };
        "${pluginDir}/displayMirror" = {
          source = mirror;
        };

        "DankMaterialShell/plugin_settings.json" = {
          generator = toJSON {};
          value = {
            dankBatteryAlerts = {
              enabled = true;
            };
            dankKDEConnect = {
              enabled = true;
              selectedDeviceId = "6343c64e7760410ba0e7750fe8a99633";
            };
            dankNotepadModule = {
              enabled = true;
              style = "catppuccin-frappe";
            };
            screenRecorder = {
              enabled = true;
            };
            displayMirror = {
              enabled = true;
              autoRefresh = false;
            };
          };
        };
      };
    };
  };
}
