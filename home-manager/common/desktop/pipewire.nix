{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) singleton;
in
  # NOTE: 'programs.dconf.enable = true' is necessary for theb daemon to work correctly
  {
    home.packages = [pkgs.pwvucontrol];

    services.easyeffects.enable = true;
    xdg.configFile."easyeffects/output" = {
      source = pkgs.fetchFromGitHub {
        owner = "JackHack96";
        repo = "EasyEffects-Presets";
        rev = "069195c4e73d5ce94a87acb45903d18e05bffdcc";
        hash = "sha256-nXVtX0ju+Ckauo0o30Y+sfNZ/wrx3HXNCK05z7dLaFc=";
      };
      recursive = true;
    };

    programs.niri.settings.window-rules = singleton {
      matches = [
        {app-id = "^(com.github.wwmm.easyeffects)$";}
        {app-id = "^(com.saivert.pwvucontrol)$";}
      ];
      open-floating = true;
    };

    custom.persist = {
      home.directories = [
        ".config/easyeffects"
      ];
    };
  }
