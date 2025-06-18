{
  lib,
  config,
  pkgs,
  self,
  isLaptop,
  ...
}:
let
  opacity = config.stylix.opacity.popups * 255 |> builtins.ceil |> lib.toHexString;
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
          layer = "overlay";
          placeholder = "Type to search...";
          prompt = "'❯ '";
          font =
            with config.stylix.fonts;
            let
              sizeParamater = if isLaptop then 2 else (-2);
            in
            "${sansSerif.name}:size=${sizes.popups - sizeParamater |> builtins.toString}";
          icon-theme = config.stylix.iconTheme.dark;
          match-counter = true;
          terminal = "${config.custom.terminal.exec}";
          width = 24;
          lines = 12;
          horizontal-pad = 25;
          vertical-pad = 8;
          inner-pad = 5;
        };
        border = {
          width = 2;
          radius = 10;
        };
        colors = with config.lib.stylix.colors; {
          background = "${base00-hex}${opacity}";
          border = "${base0B-hex}ff";
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
      #     "Alt+Tab" = {
      #       action = spawn "fuzzel-windows";
      #       hotkey-overlay.title = "Windows Search";
      #     };
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
    };
  };
}
