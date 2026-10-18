{config, ...}: let
  inherit (config.flake.custom.wrappers) mkNoctalia;
in {
  perSystem = {pkgs, ...}: {
    packages.noctalia = mkNoctalia {
      inherit pkgs;
    };
  };

  flake.custom.wrappers = {
    mkNoctalia = {
      pkg ? pkgs.noctalia,
      pkgs,
      extraRuntimeInputs ? [],
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

      noctalia-wrapper = pkgs.writeShellScript "noctalia-wrapper" ''
        exec $(cat ~/.local/share/noctalia_path) "$@"
      '';

      noctalia-path = pkgs.writeShellScript "noctalia-path" ''
        mkdir -p ~/.local/share
        echo $(whereis noctalia | awk '{print $2}') > ~/.local/share/noctalia_path
      '';
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
      };
  };
}
