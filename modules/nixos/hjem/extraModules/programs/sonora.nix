{
  config,
  pkgs,
  ...
}: let
  inherit
    (pkgs.lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    ;
  cfg = config.rum.programs.sonora;
  jsonFmt = pkgs.formats.json {};
in {
  options.rum = {
    programs.sonora = {
      enable = mkEnableOption "A native music streaming client, built with Rust and GPUI";
      package = mkPackageOption pkgs "sonora" {};
      settings = mkOption {
        inherit (jsonFmt) type;
        default = {};
      };
    };
  };

  config = mkIf cfg.enable {
    packages = [cfg.package];
    xdg.config.files = {
      "sonora/settings.json" = {
        generator = jsonFmt.generate "settings.json";
        value = cfg.settings;
      };
    };
  };
}
