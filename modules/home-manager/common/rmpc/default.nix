{lib, ...}: let
  inherit (lib) singleton;
  inherit (lib.custom.colors) orange_base;
  inherit (lib.custom.niri) spawn hotkey;
in {
  imports = [
    ./config.nix
    ./theme.nix
  ];

  programs = {
    rmpc.enable = true;

    niri.settings = {
      binds = {
        "Mod+R" = {
          action.spawn = spawn "foot --app-id=rmpc rmpc";
          hotkey-overlay.title = hotkey {
            color = orange_base;
            name = "  rmpc";
            text = "Terminal MPD Client";
          };
        };
      };
      window-rules = [
        {
          matches = singleton {
            app-id = "^rmpc$";
          };
          open-floating = true;
          default-column-width.proportion = 0.35;
          default-window-height.proportion = 0.28;
        }
      ];
    };
  };

  custom.persist = {
    home.cache.directories = [
      ".cache/rmpc/youtube"
    ];
  };
}
