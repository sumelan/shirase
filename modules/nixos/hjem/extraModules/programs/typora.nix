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

  cfg = config.rum.programs.typora;
  jsonFmt = pkgs.formats.json {};
in {
  options.rum = {
    programs.typora = {
      enable = mkEnableOption "A minimal Markdown editor and reader.";
      package = mkPackageOption pkgs "typora" {};
      advancedSettings = mkOption {
        inherit (jsonFmt) type;
        default = {};
        description = ''
          Advanced Settings File for Linux.
          See <https://support.typora.io/Advance-Config/> for details.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    packages = [cfg.package];

    xdg.config.files = let
      catppuccin = pkgs.fetchFromGitHub {
        owner = "xiongxianzhu";
        repo = "catppuccin-typora";
        rev = "6101ec29c838f30e179533b1cfef57fb86c9087a";
        hash = "sha256-IV/+t8mkZCIWyt9eMPddsMyn5KYTaGzJdVNh3Jh+ajo=";
      };
    in {
      "Typora/conf/conf.user.json" = {
        generator = jsonFmt.generate "conf.user.json";
        value = cfg.advancedSettings;
      };

      "Typora/themes/catppuccin-frappe.css".source = "${catppuccin}/catppuccin-frappe.css";
    };
  };
}
