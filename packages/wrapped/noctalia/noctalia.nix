{
  pkgs,
  pkg ? pkgs.noctalia,
  extraRuntimeInputs ? [],
  ...
}: let
  noctalia-wrapper = pkgs.writeShellScript "noctalia-wrapper" ''
    exec $(cat ~/.local/share/noctalia_path) "$@"
  '';

  noctalia-path = pkgs.writeShellScript "noctalia-path" ''
    mkdir -p ~/.local/share
    echo $(whereis noctalia | awk '{print $2}') > ~/.local/share/noctalia_path
  '';
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
    paths = [pkg];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      cp -r ${noctalia-wrapper} $out/bin/noctalia-wrapper
      cp -r ${noctalia-path} $out/bin/noctalia-path

      rm $out/bin/.noctalia-wrapped

      wrapProgram $out/bin/noctalia \
        --prefix PATH : ${runtimeEnv}/bin \
        --set FONTCONFIG_FILE ${pkgs.makeFontsConf {inherit fontDirectories;}}
    '';
    meta.mainProgram = "noctalia";
  }
