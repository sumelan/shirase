{
  self,
  pkgs,
}: let
  runtimeEnv = pkgs.buildEnv {
    name = "just-runtime-env";
    pathsToLink = ["/bin"];
    paths = with pkgs;
      [
        hyperfine
      ]
      ++ (with self.packages.${stdenv.hostPlatform.system}; [
        nushell
      ]);
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
