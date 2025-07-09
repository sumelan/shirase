{
  lib,
  config,
  inputs,
  ...
}:
{
  imports =
    [
      inputs.maomaowm.hmModules.maomaowm
    ]
    ++ [
      ./settings
      ./waybar
      ./autostart.nix
      ./idle.nix
      ./lock.nix
      ./monitors.nix
      ./wallpaper.nix
    ];

  options.custom = {
    maomaowm.enable = lib.mkEnableOption "maomaowm" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.maomaowm.enable {
    wayland.windowManager.maomaowm = {
      enable = true;
    };
  };
}
