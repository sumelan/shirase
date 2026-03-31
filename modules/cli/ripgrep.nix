{
  inputs,
  lib,
  ...
}: let
  inherit (lib) getExe;
in {
  perSystem = {pkgs, ...}: let
    ignoreFile = pkgs.writeText "ripgrep-ignore" ''
      .envrc
      .direnv
      .devenv
      .ignore
      *.lock
      generated.nix
      generated.json
    '';
  in {
    packages.ripgrep = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.ripgrep;
      flags = {
        "--smart-case" = true;
        "--ignore-file" = toString ignoreFile;
      };
    };
  };

  flake.modules.nixos = {
    default = {pkgs, ...}: {
      nixpkgs.overlays = [
        (_: _prev: {
          inherit (pkgs.custom) ripgrep;
        })
      ];
    };

    hjem-default = {pkgs, ...}: {
      hj.packages = [
        pkgs.ripgrep # overlay-ed above
      ];

      custom.programs.print-config = let
        cmd =
          # sh
          ''moor --lang sh "${getExe pkgs.ripgrep}"'';
      in {
        rg = cmd;
        ripgrep = cmd;
      };
    };
  };
}
