{config, ...}: {
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
            --add-flags "-quit-if-one-screen" \
            --add-flags "-no-linenumbers" \
            --add-flags "-statusbar bold" \
            --add-flags "-terminal-fg"
        '';
        meta.mainProgram = "moor";
      };
  };
}
