{
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.dankMaterialShell.plugins;
  jsonFormat = pkgs.formats.json {};
  pluginsRepo = pkgs.custom.dms-plugins.src;
in {
  programs.dankMaterialShell.plugins = {
    "dankBatteryAlerts" = {
      inherit (config.custom.battery) enable;
      src = "${pluginsRepo}/DankBatteryAlerts";
    };
  };
  xdg.configFile."DankMaterialShell/plugin_settings.json" = {
    source = jsonFormat.generate "plugins_settings.json" {
      dankBatteryAlerts = {
        enabled = cfg."dankBatteryAlerts".enable;
        criticalThreshold = 10;
        enableCriticalAlert = true;
        criticalTitle = "Critical Battery Level";
        criticalMessage = ''Battery at ''${level}% - Connect charger immediately!'';
        enableWarningAlert = true;
        warningThreshold = 20;
        warningTitle = "Low Battery";
        warningMessage = ''Battery at ''${level}% - Consider charging soon'';
      };
    };
  };
}
