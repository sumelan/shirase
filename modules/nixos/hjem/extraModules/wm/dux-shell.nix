{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) mkEnableOption mkPackageOption mkOption mkIf;
  jsonFmt = pkgs.formats.json {};
  cfg = config.rum.programs.dux-shell;
in {
  options.rum = {
    programs.dux-shell = {
      enable = mkEnableOption "dux-shell";
      package = mkPackageOption pkgs "dux-shell" {};
      settings = mkOption {
        inherit (jsonFmt) type;
        default = {};
        description = ''
          congifuration of dux-shell `settings.json`.
        '';
      };
      plugin_settings = mkOption {
        inherit (jsonFmt) type;
        default = {};
        description = ''
          congifuration of dux-shell plugin `plugin_settings.json`.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.config.files = {
      "dms/.changelog-2.0" = {
        permissions = "666";
        text = "2.0";
        type = "copy";
      };
      "dms/.firstlaunch" = {
        permissions = "666";
        text = "";
        type = "copy";
      };
      "dms/settings.json" = {
        generator = jsonFmt.generate "settings.json";
        value = cfg.settings;
      };
      "dms/plugin_settings.json" = {
        generator = jsonFmt.generate "plugin_settings.json";
        value = cfg.plugin_settings;
      };
    };
  };
}
