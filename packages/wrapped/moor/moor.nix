{
  config,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.moor = config.flake.custom.wrappers.mkMoor {
      inherit pkgs;
    };
  };

  flake.custom.wrappers = {
    mkMoor = {pkgs}:
      pkgs.symlinkJoin {
        name = "moor";
        paths = [pkgs.moor];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/moor \
            --set MOOR '--statusbar=bold --style=nordic'
        '';
        meta.mainProgram = "moor";
      };
  };
}
