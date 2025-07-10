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
      ./scripts
      ./settings
      ./autostart.nix
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
