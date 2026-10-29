{
  pkgs,
  functions,
  extraOptions ? "",
  extraActions ? "",
  extraKeybindings ? "",
  extraRawConfig ? "",
}: let
  inherit (functions.print) wrappedConfig;

  pqivConfig = import ./_config.nix {
    inherit
      pkgs
      extraOptions
      extraActions
      extraKeybindings
      extraRawConfig
      ;
  };

  printPkg = wrappedConfig pqivConfig {
    name = "pqiv-print-config";
  };
in
  pkgs.symlinkJoin {
    name = "pqiv";
    paths = with pkgs; [pqiv];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      ln -s ${printPkg}/bin/pqiv-print-config $out/bin/pqiv-print-config

      wrapProgram $out/bin/pqiv \
        --set PQIVRC_PATH ${pqivConfig}
    '';
    meta.mainProgram = "pqiv";
  }
