_: {
  flake.modules.homeManager.plugins = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.programs.dank-material-shell.plugins;
    jsonFormat = pkgs.formats.json {};
    pluginsRepo = pkgs.custom.dms-plugins.src;
  in {
    programs.dank-material-shell.plugins = {
      "dankBatteryAlerts" = {
        enable = true;
        src = "${pluginsRepo}/DankBatteryAlerts";
      };
    };

    xdg.configFile = {
      "DankMaterialShell/plugin_settings.json" = {
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
    };
  };
}
