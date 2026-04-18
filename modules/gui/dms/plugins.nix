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
            enableWarningAlert = true;
            warningThreshold = 20;
            warningTitle = "Low Battery";
            warningMessage = "Battery at \${level}% - Consider charging soon";
            enableCriticalAlert = true;
            criticalThreshold = 10;
            criticalTitle = "Critical Battery Level";
            criticalMessage = "Battery at \${level}% - Connect charger immediately!";
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
