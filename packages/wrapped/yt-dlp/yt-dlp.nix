{
  pkgs,
  functions,
  extraConfig ? {},
  extraRuntimeInputs ? [],
  ...
}: let
  inherit
    (pkgs.lib)
    pipe
    mapAttrsToList
    isBool
    isList
    remove
    concatStringsSep
    recursiveUpdate
    ;
  inherit (functions.print) wrappedConfig;

  ytdlpConfig = let
    cfg = import ./_config.nix {};

    toYtdlpConf = settings: let
      singleOption = name: value: let
        isShort = builtins.stringLength name == 1;
        prefix =
          if isShort
          then "-"
          else "--";
      in
        if isBool value
        then
          if value
          then "${prefix}${name}"
          else if isShort
          then ""
          else "--no-${name}"
        else "${prefix}${name} ${toString value}";
    in
      pipe settings [
        (mapAttrsToList (
          name: value:
            if isList value
            then (map (singleOption name) value)
            else [(singleOption name value)]
        ))
        builtins.concatLists
        (remove "")
        (concatStringsSep "\n")
      ];
  in
    pkgs.writeTextFile {
      name = "yt-dlp.conf";
      text = toYtdlpConf (recursiveUpdate cfg extraConfig);
    };

  runtimeEnv = pkgs.buildEnv {
    name = "ytdlp-runtime-env";
    pathsToLink = ["/bin"];
    paths = with pkgs;
      [
        ffmpeg
        (python313.withPackages (ps: [ps.mutagen]))
      ]
      ++ extraRuntimeInputs;
  };

  printPkg = wrappedConfig ytdlpConfig {
    name = "ytdlp-print-config";
    lang = "ini";
  };
in
  pkgs.symlinkJoin {
    name = "yt-dlp";
    paths = with pkgs; [yt-dlp];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      ln -s ${printPkg}/bin/ytdlp-print-config $out/bin/ytdlp-print-config

      rm -f $out/bin/.yt-dlp-wrapped

      wrapProgram $out/bin/yt-dlp \
        --add-flags "--config-location ${ytdlpConfig}" \
        --prefix PATH : ${runtimeEnv}/bin
    '';
    meta.mainProgram = "yt-dlp";
  }
