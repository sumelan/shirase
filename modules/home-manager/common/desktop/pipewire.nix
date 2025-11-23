# NOTE: `programs.dconf.enable = true` is necessary for theb daemon to work correctly
{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) singleton;
  outputSrc = pkgs.fetchFromGitHub {
    owner = "JackHack96";
    repo = "EasyEffects-Presets";
    rev = "069195c4e73d5ce94a87acb45903d18e05bffdcc";
    hash = "sha256-nXVtX0ju+Ckauo0o30Y+sfNZ/wrx3HXNCK05z7dLaFc=";
  };
  outputSet = preset: {
    ".local/share/easyeffects/output/${preset}.json".source = "${outputSrc}/${preset}.json";
  };
in {
  services.easyeffects.enable = true;

  home = {
    packages = [pkgs.pwvucontrol];
    file =
      # This preset is targeted for laptop speakers and tries to improve both lower and higher frequencies.
      # It also tries to normalize the volumes in different medias like speech and music. More information can be found in this blog.
      outputSet "Advanced Auto Gain"
      // outputSet "Bass Boosted"
      # This preset is based on Ziyad Nazem's "Perfect EQ" combined with the Razor surround impulse response.
      // outputSet "Bass Enhancing + Perfect EQ"
      # This preset is based on Ziyad Nazem's "Boosted" equalizer settings, which especially enhance lower frequencies
      // outputSet "Boosted"
      # This preset is targeted for laptop speakers to get clear voice locals and prevent dimming of sound when bass part gets played.
      # More info can be found on Digtalone1's github
      // outputSet "Loudness+Autogain"
      # This preset only enables Ziyad Nazem's "Perfect EQ"
      // outputSet "Perfect EQ"
      // {
        ".local/share/easyeffects/irs" = {
          source = "${outputSrc}/irs";
          recursive = true;
        };
      };
  };

  programs.niri.settings.window-rules = [
    {
      matches = singleton {
        app-id = "^(com.saivert.pwvucontrol)$";
      };
      open-floating = true;
    }
    {
      matches = singleton {
        app-id = "^(com.github.wwmm.easyeffects)$";
      };
      open-floating = true;
      default-column-width.proportion = 0.5;
      default-window-height.proportion = 0.5;
    }
  ];

  custom.persist = {
    home.directories = [
      ".config/easyeffects/db"
      # autoload local preset per devices
      ".local/share/easyeffects/autoload"
    ];
  };
}
