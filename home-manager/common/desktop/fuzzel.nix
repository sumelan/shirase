{
  lib,
  config,
  pkgs,
  user,
  isLaptop,
  ...
}:
let
  opacity = config.stylix.opacity.popups * 255 |> builtins.ceil |> lib.toHexString;
in
{
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
          terminal = "${lib.getExe config.profiles.${user}.defaultTerminal.package}";
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
    niri.settings.binds = {
      "Mod+D" = lib.custom.niri.openApp {
        app = pkgs.fuzzel;
      };
      "Mod+Q" = lib.custom.niri.runCmd {
        cmd = "fuzzel-actions";
        title = "Open Actions menu";
      };
      "Mod+V" = lib.custom.niri.runCmd {
        cmd = "fuzzel-clipboard";
        title = "Search for clipboard history";
      };
    };
  };
  stylix.targets.fuzzel.enable = false;
}
