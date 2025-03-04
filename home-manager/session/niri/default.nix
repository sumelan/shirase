{
  lib,
  config,
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
    ./startup.nix
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
    custom.autologinCommand = "niri-session";
  };
}
