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

      xdg.config.files = let
        nord = pkgs.fetchFromGitHub {
          owner = "ChristosBouronikos";
          repo = "typora-nord-theme";
          rev = "v1.2";
          hash = "sha256-o9lUa6be/sCaNmh/cYYFGHspE0AvR5fCzt1ULUDfc/s=";
        };

        blue-topaz = pkgs.fetchFromGitHub {
          owner = "LingJingMaster";
          repo = "typora-theme-blue-topaz";
          rev = "4ccf8bca875c4031b9213edcba79b9c057e0123d";
          hash = "sha256-BXfDfjntkDtnz0YYYfs/PNhbHPvHOe42UO7A/DP31l4=";
        };
      in {
        "Typora/conf/conf.user.json" = {
          generator = jsonFmt.generate "conf.user.json";
          value = cfg.advancedSettings;
        };

        "Typora/themes/nord.css".source = "${nord}/nord.css";
        "Typora/themes/blue-topaz.css".source = "${blue-topaz}/blue-topaz.css";
      };
    };
  };
}
