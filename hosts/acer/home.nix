{
  lib,
  pkgs,
  ...
}: {
  monitors = {
    "eDP-1" = {
      isMain = true;
      scale = 1.0;
      mode = {
        width = 1920;
        height = 1200;
        refresh = 60.0;
      };
      position = {
        x = 0;
        y = 0;
      };
      rotation = 0;
    };
  };

  custom = let
    enableList = [
      "cyanrip"
      "foliate"
      "freetube"
      "helix"
      "obs-studio"
      "protonapp"
    ];
    disableList = [
      "wlsunset"
    ];
  in
    {
      stylix = {
        cursor = {
          package = pkgs.nordzy-cursor-theme;
          name = "Nordzy-cursors-white";
        };
        icons = {
          package = pkgs.colloid-icon-theme.overrideAttrs (_old: rec {
            schemeVariants = ["nord"];
            colorVariants = ["grey"]; # default is blue

            version = "2025-07-19";

            src = pkgs.fetchFromGitHub {
              owner = "vinceliuice";
              repo = "Colloid-icon-theme";
              rev = version;
              hash = "sha256-CzFEMY3oJE3sHdIMQQi9qizG8jKo72gR8FlVK0w0p74=";
            };

            dontCheckForBrokenSymlinks = true;

            installPhase = ''
              runHook preInstall

              name= ./install.sh \
                ${lib.optionalString (schemeVariants != []) ("--scheme " + builtins.toString schemeVariants)} \
                ${lib.optionalString (colorVariants != []) ("--theme " + builtins.toString colorVariants)} \
                --dest $out/share/icons

              jdupes --quiet --link-soft --recurse $out/share

              runHook postInstall
            '';
          });
          dark = "Colloid-Grey-Nord-Dark";
        };
      };
    }
    // lib.genAttrs enableList (_name: {
      enable = true;
    })
    // lib.genAttrs disableList (_name: {
      enable = false;
    });
}
