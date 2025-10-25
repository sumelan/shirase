{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    singleton
    ;
in {
  options.custom = {
    swww.enable = mkEnableOption "swww";
  };

  config = mkIf config.custom.swww.enable {
    home = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          swww
          waypaper
          ;
      };
      file.".backdrop.png".source = ./nord-night-aurora.png;
    };

    programs.niri.settings = {
      spawn-at-startup = [
        {
          argv = ["${pkgs.swww}/bin/swww-daemon"];
        }
        {
          argv = ["${pkgs.swww}/bin/swww-daemon" "--namespace" "backdrop"];
        }
        {
          argv = ["${pkgs.swww}/bin/swww" "img" "--namespace" "backdrop" "${config.home.homeDirectory}/.backdrop"];
        }
      ];
      window-rules = [
        {
          matches = singleton {
            app-id = "^(waypaper)$";
          };
          open-floating = true;
        }
      ];
      layer-rules = [
        {
          matches = singleton {
            namespace = "^(swww-daemon)$";
          };
          opacity = 0.7;
        }
        {
          matches = singleton {
            namespace = "backdrop";
          };
          place-within-backdrop = true;
          opacity = 1.0;
        }
      ];
    };

    custom.persist = {
      home.cache.directories = [
        ".cache/swww"
        ".cache/waypaper"
      ];
    };
  };
}
