{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages.difftastic = config.flake.custom.wrappers.mkDifftastic {
      inherit pkgs;
    };
  };

  flake.custom.wrappers = {
    mkDifftastic = {pkgs}:
      pkgs.symlinkJoin {
        name = "difft";
        paths = [pkgs.difftastic];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/difft \
            --add-flags "--backgroun dark"
        '';
        meta.mainProgram = "difft";
      };
  };
}
