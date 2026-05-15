{
  inputs,
  lib,
  ...
}: let
  inherit (inputs.niri-nix.lib) validatedConfigFor mkNiriKDL;
in {
  flake.modules.nixos.niri = {
    config,
    pkgs,
    dotfile,
    ...
  }: {
    hj.xdg.config.files = let
      inherit (config.programs.niri) package;

      niriCfg = import ./_config.nix {inherit config lib pkgs dotfile;};
    in {
      "niri/config.kdl".source = validatedConfigFor package (mkNiriKDL niriCfg);
    };
  };
}
