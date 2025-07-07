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
      ./waybar
      ./settings.nix
      ./autostart.nix
      ./wallpaper.nix
    ];

  options.custom = {
    maomaowm.enable = lib.mkEnableOption "maomaowm";
  };

  config = lib.mkIf config.custom.maomaowm.enable {
    wayland.windowManager.maomaowm = {
      enable = true;
    };
  };
}
