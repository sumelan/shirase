{lib, ...}: let
  inherit (lib.custom.colors) magenta_base;
  inherit (lib.custom.niri) spawn hotkey;
in {
  programs = {
    vesktop = {
      enable = true;
    };

    niri.settings = {
      binds = {
        "Mod+D" = {
          action.spawn = spawn "vesktop";
          hotkey-overlay.title = hotkey {
            color = magenta_base;
            name = "  Vesktop";
            text = "Discord Client";
          };
        };
      };
    };
  };

  custom.persist = {
    home.directories = [
      ".config/vesktop"
    ];
  };
}
