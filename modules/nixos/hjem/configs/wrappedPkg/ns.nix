{customLib, ...}: let
  inherit (customLib.niri) hotkey;
in {
  custom.wayland.windowManager.niri.extraBinds = {
    "Mod+Shift+N" = {
      _props.hotkey-overlay-title = hotkey {
        color = "#8caaee";
        name = "󱄅  Nix Search TV";
        desc = "Fuzzy search for Nix packages";
      };
      spawn = ["monstar" "--title" "nix-search-tv" "-e" "ns"];
    };
  };
}
