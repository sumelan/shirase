{
  pkgs,
  extraRuntimeInputs ? [],
  ...
}: let
  runtimeEnv = pkgs.buildEnv {
    name = "noctalia-runtime-env";
    pathsToLink = ["/bin"];
    paths = with pkgs;
      [
        ddcutil
        mpvpaper
      ]
      ++ extraRuntimeInputs;
  };

  fontDirectories = with pkgs; [
    montserrat
    maple-mono.NF-unhinted
  ];
in
  pkgs.symlinkJoin {
    name = "noctalia";
    paths = with pkgs; [noctalia];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      rm -f $out/bin/.noctalia-wrapped

      wrapProgram $out/bin/noctalia \
        --prefix PATH : ${runtimeEnv}/bin \
        --set FONTCONFIG_FILE ${pkgs.makeFontsConf {inherit fontDirectories;}}
    '';
    meta.mainProgram = "noctalia";
  }
