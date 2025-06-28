{ lib, pkgs, ... }:
# NOTE: 'programs.dconf.enable = true' is necessary for theb daemon to work correctly
{
  services.easyeffects = {
    enable = true;
    package = pkgs.easyeffects;
  };

  xdg.configFile."easyeffects/output" = {
    source = pkgs.fetchFromGitHub {
      owner = "JackHack96";
      repo = "EasyEffects-Presets";
      rev = "069195c4e73d5ce94a87acb45903d18e05bffdcc";
      hash = "sha256-nXVtX0ju+Ckauo0o30Y+sfNZ/wrx3HXNCK05z7dLaFc=";
    };
    recursive = true;
  };

  programs.niri.settings.window-rules = lib.singleton {
    matches = lib.singleton {
      app-id = "^(com.github.wwmm.easyeffects)$";
    };
    open-floating = true;
    default-column-width.proportion = 0.4;
    default-window-height.proportion = 0.4;
  };

  custom.persist = {
    home.directories = [
      ".config/easyeffects"
    ];
  };
}
