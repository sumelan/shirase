{lib, ...}: {
  flake.custom.hjemModules.typora = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.programs.typora;
    jsonFmt = pkgs.formats.json {};
  in {
    options.rum = {
      programs.typora = {
        enable = lib.mkEnableOption "A minimal Markdown editor and reader.";

        package = lib.mkPackageOption pkgs "typora" {};

        advancedSettings = lib.mkOption {
          inherit (jsonFmt) type;
          default = {};
          description = ''
            Advanced Settings File for Linux.
            See <https://support.typora.io/Advance-Config/> for details.
          '';
        };
      };
    };

    config = lib.mkIf cfg.enable {
      packages = [cfg.package];

      xdg.config.files."Typora/conf/conf.user.json" = {
        generator = jsonFmt.generate "conf.user.json";
        value = cfg.advancedSettings;
      };
    };
  };
}
