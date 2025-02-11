{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./animations.nix
    ./idle.nix
    ./keybinds.nix
    ./lock.nix
    ./rules.nix
    ./settings.nix
  ];

  options.custom = with lib; {
    niri = {
      enable = mkEnableOption "niri" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.custom.niri.enable {
    # start niri-session
    custom.autologinCommand = "${lib.getExe pkgs.niri-stable}-session";
    home.packages = with pkgs; [
      swww
      # clipboard history
      cliphist
      wl-clipboard
    ];

    home.file.".config/niri/scripts" = {
      source = ./scripts;
    };
  };
}
