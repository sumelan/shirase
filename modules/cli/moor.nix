{
  inputs,
  lib,
  ...
}: let
  inherit (lib) getExe;
in {
  perSystem = {pkgs, ...}: {
    packages.moor = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.moor;
      flags = {
        "--quit-if-one-screen" = true;
        "--no-linenumbers" = true;
        "--statusbar" = "bold";
        "-terminal-fg" = true;
      };
    };
  };

  flake.modules.nixos.default = {pkgs, ...}: {
    nixpkgs.overlays = [
      (_: _prev: {
        inherit (pkgs.custom) moor;
      })
    ];

    hj.packages = [
      pkgs.moor # overlay-ed above
    ];

    environment = {
      shellAliases = {
        less = "moor";
      };
      sessionVariables = {
        PAGER = "moor";
        SYSTEMD_PAGER = "moor";
        SYSTEMD_PAGERSECURE = "1";
      };
    };

    custom.programs.print-config = {
      moor =
        # sh
        ''moor --lang sh "${getExe pkgs.moor}"'';
    };
  };
}
