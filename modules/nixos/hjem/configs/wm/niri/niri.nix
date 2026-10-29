{
  config,
  pkgs,
  functions,
  ...
}: let
  inherit (pkgs.lib) mkOption;
  inherit (pkgs.lib.types) bool;
  inherit (functions.recursive) attrsList;
in {
  options.custom = {
    wayland.windowManager.niri = {
      xwayland = mkOption {
        type = bool;
        default = false;
      };
    };
  };

  config = {
    hjem.users.sumelan.rum = {
      wayland.windowManager.niri = {
        enable = true;
        inherit (config.programs.niri) package;
        settings = attrsList [
          (import ./_config.nix {inherit config pkgs;})
          (import ./_animation.nix {})
          (import ./_binds.nix {})
          (import ./_rules.nix {})
        ];
      };
    };
  };
}
