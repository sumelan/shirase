{
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit (inputs.niri-nix.lib) validatedConfigFor mkNiriKDL;
  inherit (pkgs.lib) mkEnableOption mkPackageOption mkOption mkIf;
  inherit (pkgs.lib.types) attrs;
  cfg = config.rum.wayland.windowManager.niri;
in {
  options.rum = {
    wayland.windowManager.niri = {
      enable = mkEnableOption "niri";
      package = mkPackageOption pkgs "niri" {};
      settings = mkOption {
        type = attrs;
        default = {};
        description = ''
          Congifuration of niri included in `config.kdl`.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.config.files = let
      finalKDL =
        mkNiriKDL cfg.settings
        +
        # kdl
        ''
          include "dms/alttab.kdl" optional=true
          include "dms/binds.kdl" optional=true
          include "dms/colors.kdl" optional=true
          include "dms/cursor.kdl" optional=true
          include "dms/input.kdl" optional=true
          include "dms/layout.kdl" optional=true
          include "dms/outputs.kdl" optional=true
          include "dms/windowrules.kdl" optional=true
          include "dms/wpblur.kdl" optional=true
        '';
    in {
      "niri/config.kdl".source = validatedConfigFor cfg.package finalKDL;
    };
  };
}
