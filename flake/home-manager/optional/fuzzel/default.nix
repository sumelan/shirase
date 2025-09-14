{
  lib,
  config,
  user,
  ...
}: let
  inherit
    (lib)
    toHexString
    mkEnableOption
    mkIf
    getExe
    ;

  inherit
    (lib.custom.niri)
    runCmd
    ;

  opacity = config.stylix.opacity.popups * 255 |> builtins.ceil |> toHexString;
in {
  imports = [
    ./scripts
  ];

  options.custom = {
    fuzzel = {
      enable = mkEnableOption "Fuzzel";
    };
  };

  config = mkIf config.custom.fuzzel.enable {
    programs = {
      fuzzel = {
        enable = true;
        settings = {
          main = {
            layer = "overlay";
            placeholder = "Type to search...";
            prompt = "'❯ '";
            font = with config.stylix.fonts; "${sansSerif.name}:size=${sizes.popups |> builtins.toString}";
            icon-theme = config.gtk.iconTheme.name;
            match-counter = true;
            terminal = "${getExe config.profiles.${user}.defaultTerminal.package}";
            width = 26;
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
        "Mod+Ctrl+Backslash" = runCmd {
          cmd = "dynamic-screencast-target";
          title = "niri Dynamic Cast Target";
        };
      };
    };
    stylix.targets.fuzzel.enable = false;
  };
}
