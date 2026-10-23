{
  pkgs,
  functions,
  extraConfig ? {},
  ...
}: let
  inherit (functions.print) wrappedConfig;

  starshipConfig = import ./_config.nix {inherit pkgs extraConfig;};

  printCfg = wrappedConfig starshipConfig {
    name = "starship-print-config";
    lang = "toml";
  };
in
  pkgs.symlinkJoin {
    name = "starship";
    paths = with pkgs; [starship];
    nativeBuildInputs = with pkgs; [makeWrapper];
    passthru.starshipConfig = starshipConfig;
    postBuild = ''
      cp -r ${printCfg}/bin $out

      wrapProgram $out/bin/starship \
        --set STARSHIP_CONFIG ${starshipConfig}
    '';
  }
