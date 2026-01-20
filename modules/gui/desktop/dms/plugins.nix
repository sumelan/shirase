{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.default = {pkgs, ...}: let
    pluginsRepo = flake.packages.${pkgs.stdenv.hostPlatform.system}.dms-plugins;
  in {
    programs.dank-material-shell = {
      plugins = {
        "dankBatteryAlerts" = {
          enable = true;
          src = "${pluginsRepo}/DankBatteryAlerts";
          settings = {
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
        };
        "dankKDEConnect" = {
          enable = true;
          src = "${pluginsRepo}/DankKDEConnect";
          settings = {
            enabled = true;
          };
        };
      };
    };
  };
}
