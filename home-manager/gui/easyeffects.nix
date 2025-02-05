{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    easyEffects = {
      enable = mkEnableOption "easy effects";
      preset = mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  config = lib.mkIf config.custom.easyEffects.enable {
    services.easyeffects = {
      enable = true;
      package = pkgs.easyeffects;
      preset = config.cudtom.easyEffects.preset;
    };

    xdg.configFile."easyeffects/output".source = pkgs.fetchFromGitHub {
      owner = "JackHack96";
      repo = "EasyEffects-Presets";
      rev = "069195c4e73d5ce94a87acb45903d18e05bffdcc";
      hash = "sha256-nXVtX0ju+Ckauo0o30Y+sfNZ/wrx3HXNCK05z7dLaFc=";
    };

    custom.persist = {
      home.directories = [
      ".config/easyeffects"
      ];
    };
  };
}


