{
  self,
  pkgs,
  functions,
  extraConfig ? {},
  extraRuntimeInputs ? [],
  ...
}: let
  inherit
    (pkgs.lib)
    recursiveUpdate
    mapAttrsToList
    concatStringsSep
    ;
  inherit (functions.print) wrappedConfig;

  ghosttyConfig = let
    cfg = import ./_config.nix {inherit pkgs;};
    binds = import ./_binds.nix {};

    configLines = mapAttrsToList (k: v: "${k} = ${toString v}") (recursiveUpdate cfg extraConfig);
    bindsLines = mapAttrsToList (k: v: "keybind = ${k}=${v}") binds;
  in
    pkgs.writeText "ghostty-wrapped-config" (concatStringsSep "\n" (configLines ++ bindsLines));

  fontDirectories = with pkgs; [
    maple-mono.NF-unhinted
  ];

  runtimeEnv = pkgs.buildEnv {
    name = "ghostty-runtime-env";
    pathsToLink = ["/bin"];
    paths = with self.packages.${pkgs.stdenv.hostPlatform.system};
      [
        nushell
      ]
      ++ extraRuntimeInputs;
  };

  printPkg = wrappedConfig ghosttyConfig {
    name = "ghostty-print-config";
    lang = "ini";
  };

  wrapped-service = import ./_service.nix {inherit pkgs ghosttyConfig;};

  wrapped-desktopItem = import ./_desktopItem.nix {inherit pkgs ghosttyConfig;};
in
  pkgs.symlinkJoin {
    name = "ghostty";
    paths = with pkgs; [ghostty];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      ln -s ${printPkg}/bin/ghostty-print-config $out/bin/ghostty-print-config

      $out/bin/ghostty --config-file=${ghosttyConfig} +validate-config

      rm -f $out/bin/.ghostty-wrapped
      rm -f $out/share/applications/com.mitchellh.ghostty.desktop
      rm -f $out/share/dbus-1/services/com.mitchellh.ghostty.service

      ln -sf ${wrapped-service} $out/share/dbus-1/services/com.mitchellh.ghostty.service
      ln -sf ${wrapped-desktopItem} $out/share/applications/com.mitchellh.ghostty.desktop

      wrapProgram $out/bin/ghostty \
        --add-flags "--config-default-files=false" \
        --add-flags "--config-file=${ghosttyConfig}" \
        --set GHOSTTY_BIN_DIR $out/bin \
        --set GHOSTTY_RESOURCES_DIR $out/share/ghostty \
        --prefix PATH : ${runtimeEnv}/bin \
        --set FONTCONFIG_FILE ${pkgs.makeFontsConf {inherit fontDirectories;}}
    '';
    meta.mainProgram = "ghostty";
  }
