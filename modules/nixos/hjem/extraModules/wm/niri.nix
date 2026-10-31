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
    xdg.config.files = {
      "niri/config.kdl".source = validatedConfigFor cfg.package (mkNiriKDL cfg.settings);
    };
  };
}
