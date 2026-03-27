{lib, ...}: let
  inherit (lib) mkOption concatLines attrNames mapAttrsToList;
  inherit (lib.types) attrsOf str;
in {
  flake.modules.homeManager.default = {
    config,
    pkgs,
    ...
  }: {
    options.custom = {
      programs.print-config = mkOption {
        type = attrsOf str;
        default = {};
        description = "Attrs of program and the command to print their config.";
      };
    };

    config = let
      config-list = pkgs.writeShellApplication {
        name = "config-list";
        text =
          # sh
          ''
            sort -ui <<< "${concatLines (attrNames config.custom.programs.print-config)}"
          '';
      };
    in {
      home.packages =
        [
          config-list
        ]
        # add a `PROGRAM-config` command for each program
        ++ (mapAttrsToList (
            prog: cmd:
              pkgs.writeShellApplication {
                name = "${prog}-config";
                runtimeInputs = [pkgs.moor];
                text = cmd;
              }
          )
          config.custom.programs.print-config);
    };
  };
}
