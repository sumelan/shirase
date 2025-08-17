{
  lib,
  config,
  pkgs,
  user,
  ...
}: {
  imports = [
    ./scripts
    ./cliphist.nix
    ./confirm.nix
    ./launcher.nix
    ./powermenu.nix
  ];

  options.custom = {
    rofi.enable =
      lib.mkEnableOption "Rofi"
      // {
        default = true;
      };
  };

  config = lib.mkIf config.custom.rofi.enable {
    programs = {
      rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        font = config.stylix.fonts.monospace.name + " " + builtins.toString config.stylix.fonts.sizes.desktop;
        terminal = "${lib.getExe config.profiles.${user}.defaultTerminal.package}";
        theme = "${config.xdg.configHome}/rofi/theme/launcher.rasi";
      };

      niri.settings.binds = {
        "Mod+D" = lib.custom.niri.openApp {
          app = config.programs.rofi.package;
          args = "-show drun";
        };
        "Mod+Q" = lib.custom.niri.runCmd {
          cmd = "powermenu";
          title = "Open Powermenu";
        };
        "Mod+V" = lib.custom.niri.runCmd {
          cmd = "clipboard-history";
          title = "Search for clipboard history";
        };
      };
    };
    stylix.targets.rofi.enable = false;
  };
}
