{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.custom.easyEffects;
in {
  options.custom.easyEffects = {
    enable = mkEnableOption "Enable easy effects";
    preset = mkOption {
      type = types.str;
      default = "";
    };
  };
  config = mkIf cfg.enable {
    services.easyeffects = {
      enable = true;
      package = pkgs.easyeffects;
      preset = cfg.preset;
    };

    xdg.configFile."easyeffects/output".source = pkgs.fetchFromGitHub {
      owner = "JackHack96";
      repo = "EasyEffects-Presets";
      rev = "069195c4e73d5ce94a87acb45903d18e05bffdcc";
      hash = "sha256-nXVtX0ju+Ckauo0o30Y+sfNZ/wrx3HXNCK05z7dLaFc=";
    };
  };
}


