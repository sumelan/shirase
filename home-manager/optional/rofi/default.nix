{
  lib,
  config,
  pkgs,
  user,
  ...
}: {
  imports = [
    ./confirm.nix
    ./launcher.nix
    ./powermenu.nix
  ];

  options.custom = {
    rofi.enable = lib.mkEnableOption "Rofi";
  };

  config = lib.mkIf config.custom.rofi.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      font = config.stylix.fonts.monospace.name + " " + builtins.toString config.stylix.fonts.sizes.desktop;
      terminal = "${lib.getExe config.profiles.${user}.defaultTerminal.package}";
      theme = "${config.xdg.configHome}/rofi/theme/launcher.rasi";
    };

    stylix.targets.rofi.enable = false;
  };
}
