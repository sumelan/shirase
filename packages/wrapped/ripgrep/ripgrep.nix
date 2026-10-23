{
  pkgs,
  functions,
  extraFiles ? "",
  ...
}: let
  inherit (functions.print) wrappedConfig;

  ignoreFiles =
    import ./_ignoreFile.nix {inherit pkgs extraFiles;};

  printPkg = wrappedConfig ignoreFiles {
    name = "ripgrep-print-ignorefiles";
  };
in
  pkgs.symlinkJoin {
    name = "rg";
    paths = with pkgs; [ripgrep];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      ln -s ${printPkg}/bin/ripgrep-print-ignorefiles $out/bin/ripgrep-print-ignorefiles

      wrapProgram $out/bin/rg \
        --add-flags "--smart-case" \
        --add-flags "--ignore-file ${ignoreFiles}"
    '';
    meta.mainProgram = "rg";
  }
