{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./animations.nix
    ./keybinds.nix
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
    custom.autologinCommand = "${lib.getExe pkgs.niri-stable}/bin/niri-session";
    home.packages = with pkgs; [
      swww
      # clipboard history
      wl-clipboard
    ];
  };
}
