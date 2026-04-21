{lib, ...}: let
  inherit (lib.generators) toJSON;
in {
  flake.modules.nixos.gui = {pkgs, ...}: let
    pluginDir = "DankMaterialShell/plugins";
    pluginsRepo = pkgs.custom.dms-plugins;
  in {
    hj.xdg.config.files = {
      "${pluginDir}/dankBatteryAlerts" = {
        source = "${pluginsRepo}/DankBatteryAlerts";
      };
      "${pluginDir}/dankKDEConnect" = {
        source = "${pluginsRepo}/DankKDEConnect";
      };
      "${pluginDir}/dankNotepadModule" = {
        source = "${pluginsRepo}/DankNotepadModule";
      };

      "DankMaterialShell/plugin_settings.json" = {
        generator = toJSON {};
        value = {
          dankBatteryAlerts = {
            enabled = true;
          };
          dankKDEConnect = {
            enabled = true;
          };
          dankNotepadModule = {
            enabled = true;
            style = "catppuccin-frappe";
          };
        };
      };
    };
  };
}
