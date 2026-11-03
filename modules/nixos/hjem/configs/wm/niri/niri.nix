{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) mkOption;
  inherit
    (pkgs.lib.types)
    bool
    attrs
    listOf
    ;
in {
  options.custom = {
    wayland.windowManager.niri = {
      extraBinds = mkOption {
        type = attrs;
        default = {};
      };
      extraWindow-rule = mkOption {
        type = listOf attrs;
        default = [];
      };
      extraLayer-rule = mkOption {
        type = listOf attrs;
        default = [];
      };
      xwayland = mkOption {
        type = bool;
        default = false;
      };
    };
  };

  config = {
    hjem.users.sumelan.rum = {
      wayland.windowManager.niri = {
        inherit (config.programs.niri) enable package;
      };
    };
  };
}
