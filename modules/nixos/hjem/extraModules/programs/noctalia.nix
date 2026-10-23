{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) mkIf mkEnableOption mkPackageOption mkOption;
  cfg = config.rum.programs.noctalia;
  tomlFmt = pkgs.formats.toml {};
in {
  options.rum = {
    programs.noctalia = {
      enable = mkEnableOption "Sleek, customizable desktop shell crafted for wayland";
      package = mkPackageOption pkgs "noctalia" {};
      settings = mkOption {
        inherit (tomlFmt) type;
        default = {};
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.config.files = {
      "noctalia/config.toml" = {
        generator = tomlFmt.generate "config.toml";
        value = cfg.settings;
      };
    };
  };
}
