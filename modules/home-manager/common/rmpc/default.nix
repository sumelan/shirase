{lib, ...}: let
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
          action.spawn = spawn "ghostty -e rmpc";
          hotkey-overlay.title = hotkey {
            color = orange_base;
            name = "  rmpc";
            text = "Terminal MPD Client";
          };
        };
      };
    };
  };

  custom.persist = {
    home.cache.directories = [
      ".cache/rmpc/youtube"
    ];
  };
}
