{
  self,
  inputs,
  pkgs,
}: let
  runtimeEnv = pkgs.buildEnv {
    name = "just-runtime-env";
    pathsToLink = ["/bin"];
    paths = with pkgs; [
      hyperfine
      self.packages.${stdenv.hostPlatform.system}.nushell
      inputs.comview.packages.${stdenv.hostPlatform.system}.default
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
