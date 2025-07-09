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
