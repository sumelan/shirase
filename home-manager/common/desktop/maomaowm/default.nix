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
      ./autostart.nix
      ./wallpaper.nix
    ];

  options.custom = {
    maomao.enable = lib.mkEnableOption "maomaowm";
  };

  config = lib.mkIf config.custom.maomao.enable {
    wayland.windowManager.maomaowm = {
      enable = true;
    };
  };
}
