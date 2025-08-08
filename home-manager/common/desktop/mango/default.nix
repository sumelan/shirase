{
  lib,
  config,
  inputs,
  ...
}: {
  imports =
    [inputs.mango.hmModules.mango]
    ++ [
      ./settings
      ./autostart.nix
    ];

  options.custom = {
    mango.enable = lib.mkEnableOption "Wayland compositor base wlroots and scenefx(dwl but no suckless)";
  };

  config = lib.mkIf config.custom.mango.enable {
    wayland.windowManager.mango = {
      enable = true;
    };
  };
}
