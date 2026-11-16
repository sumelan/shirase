{
  inputs,
  pkgs,
}: let
  comview = inputs.comview.packages.${pkgs.stdenv.hostPlatform.system}.default;

  runtimeEnv = pkgs.buildEnv {
    name = "just-runtime-env";
    pathsToLink = ["/bin"];
    paths =
      (with pkgs; [
        hyperfine
      ])
      ++ [
        comview
      ];
  };
in
  pkgs.symlinkJoin {
    name = "just";
    paths = [pkgs.just];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/just \
        --prefix PATH : ${runtimeEnv}/bin
    '';
  }
