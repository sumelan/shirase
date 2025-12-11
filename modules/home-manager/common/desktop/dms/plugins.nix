{
  config,
  pkgs,
  ...
}: let
  jsonFormat = pkgs.formats.json {};
  pluginsRepo = pkgs.custom.dms-plugins.src;
in {
  xdg.configFile = {
    # plugins
    "dankBatteryAlerts" = {
      source = "${pluginsRepo}/DankBatteryAlerts";
      recursive = true;
    };

    "DankMaterialShell/plugin_settings.json" = {
      source = jsonFormat.generate "plugins_settings.json" {
        dankBatteryAlerts = {
          enabled = config.custom.battery.enable;
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
  };
}
