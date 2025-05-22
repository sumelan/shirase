{
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  opacity = lib.toHexString (builtins.ceil (config.stylix.opacity.popups * 255));
in
{
  home.packages =
    with pkgs;
    [
      wl-clipboard
      cliphist
    ]
    ++ [ self.packages.${pkgs.system}.fuzzel-scripts ];

  programs = {
    fuzzel = {
      enable = true;
      settings = {
        main = {
          placeholder = "Type to search...";
          prompt = "'❯ '";
          font = "Maple Mono NF:size=${toString (config.stylix.fonts.sizes.popups - 2)}";
          icon-theme = config.stylix.iconTheme.dark;
          match-counter = true;
          terminal = "${pkgs.kitty}/bin/kitty";
          width = 30;
          lines = 8;
          horizontal-pad = 40;
          vertical-pad = 8;
          inner-pad = 15;
        };
        border = {
          width = 2;
          radius = 10;
        };
        colors = with config.lib.stylix.colors; {
          background = "${base00-hex}${opacity}";
          border = "${base09-hex}ff";
          counter = "${base06-hex}ff";
          input = "${base05-hex}ff";
          match = "${base0A-hex}ff";
          placeholder = "${base03-hex}ff";
          prompt = "${base05-hex}ff";
          selection = "${base03-hex}ff";
          selection-match = "${base0A-hex}ff";
          selection-text = "${base05-hex}ff";
          text = "${base05-hex}ff";
        };
      };
    };
    niri.settings.binds = with config.lib.niri.actions; {
      "Mod+D" = {
        action = spawn "fuzzel";
        hotkey-overlay.title = "Fuzzel";
      };
      "Mod+Space" = {
        action = spawn "fuzzel-files";
        hotkey-overlay.title = "File Search";
      };
      "Mod+Tab" = {
        action = spawn "fuzzel-windows";
        hotkey-overlay.title = "Windows Search";
      };
      "Mod+Ctrl+Q" = {
        action = spawn "fuzzel-actions";
        hotkey-overlay.title = "System Actions";
      };
      "Mod+Period" = {
        action = spawn "fuzzel-icons";
        hotkey-overlay.title = "Icon Search";
      };
      "Mod+V" = {
        action = spawn "fuzzel-clipboard";
        hotkey-overlay.title = "Show Clipboard History";
      };
      "Mod+Ctrl+V" = {
        action = spawn "rm" "$XDG_CACHE_HOME/cliphist/db";
        hotkey-overlay.title = "Clear Clipboard History";
      };
    };
  };
}
