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
      ln -s ${printCfg}/bin/starship-print-config $out/bin/starship-print-config

      wrapProgram $out/bin/starship \
        --set STARSHIP_CONFIG ${starshipConfig}
    '';
  }
