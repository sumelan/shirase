{config, ...}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: {
    packages.pqiv = config.flake.custom.wrappers.mkPqiv {
      inherit pkgs;
    };
  };

  flake.custom.wrappers = {
    pqivConfig = {
      pkgs,
      extraOptions ? "",
      extraActions ? "",
      extraKeybindings ? "",
      extraConfig ? "",
    }:
      import ./_config.nix {inherit pkgs extraOptions extraActions extraKeybindings extraConfig;};

    mkPqiv = {
      pkgs,
      extraOptions ? "",
      extraActions ? "",
      extraKeybindings ? "",
      extraConfig ? "",
    }: let
      cfg = "${config.flake.custom.wrappers.pqivConfig {inherit pkgs extraOptions extraActions extraKeybindings extraConfig;}}/pqivrc";

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "pqiv-print-config";
      };
    in
      pkgs.symlinkJoin {
        name = "pqiv";
        paths = [pkgs.pqiv];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          wrapProgram $out/bin/pqiv \
            --set PQIVRC_PATH ${cfg}
        '';
        meta.mainProgram = "pqiv";
      };
  };
}
