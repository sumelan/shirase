{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.default = {pkgs, ...}: let
    jsonFormat = pkgs.formats.json {};
    pluginsRepo = flake.packages.${pkgs.stdenv.hostPlatform.system}.dms-plugins;
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
            enabled = true;
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
