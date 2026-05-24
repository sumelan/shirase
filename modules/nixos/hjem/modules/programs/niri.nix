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
    cfg = config.rum.programs.niri;
  in {
    options.rum = {
      programs.niri = {
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

    config = {
      xdg.config.files = {
        "niri/config.kdl".source = validatedConfigFor cfg.package (mkNiriKDL cfg.settings);
      };
    };
  };
}
