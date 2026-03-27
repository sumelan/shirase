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
      pacakge = pkgs.moor;
      flags = {
        "--quit-if-one-screen" = true;
        "--no-linenumbers" = true;
        "--statusbar" = "bold";
        "-terminal-fg" = true;
      };
    };
  };

  flake.modules = {
    nixos.dafault = {pkgs, ...}: {
      mixpkgs.overlays = [
        (_: _prev: {
          inherit (pkgs.custom) moor;
        })
      ];
    };

    homeManager.default = {pkgs, ...}: {
      home = {
        packages = [
          pkgs.moor # overlay-ed above
        ];
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
  };
}
