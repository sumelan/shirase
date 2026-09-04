{
  inputs,
  lib,
  ...
}: let
  inherit (inputs.niri-nix.lib) validatedConfigFor mkNiriKDL;
in {
  flake.custom.hjemModules.niri = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.wayland.windowManager.niri;
  in {
    options.rum = {
      wayland.windowManager.niri = {
        enable = lib.mkEnableOption "niri";

        package = lib.mkPackageOption pkgs "niri" {};

        settings = lib.mkOption {
          type = lib.types.attrs;
          default = {};
          description = ''
            Congifuration of niri included in `config.kdl`.
          '';
        };
      };
    };

    config = lib.mkIf cfg.enable {
      xdg.config.files = {
        "niri/config.kdl".source = validatedConfigFor cfg.package (mkNiriKDL cfg.settings);
      };
    };
  };
}
