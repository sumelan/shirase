{self, ...}: {
  flake.modules.nvf.nix = _: {
    vim = {
      languages.nix = {
        enable = true;
        extraDiagnostics = {
          enable = true;
          types = ["deadnix" "statix"];
        };
        format = {
          enable = true;
          type = ["alejandra"];
        };
        lsp.servers = ["nixd"];
      };

      lsp.servers.nixd = {
        settings = let
          dotfile = "/persist/home/sumelan/Projects/shirase";
          hostName = "sakura";

          inputs =
            # nix
            ''(removeAttrs (import "${self}/.tack") ["" "__functor"])'';

          myFlake =
            # nix
            ''(builtins.getFlake "${dotfile}")'';
        in {
          nixpkgs.expr =
            # nix
            ''import ${inputs}.nixpkgs { }'';
          options = {
            nixos.expr =
              # nix
              ''${myFlake}.nixosConfigurations.${hostName}.options'';

            flake-parts.expr =
              # nix
              ''${myFlake}.debug.options'';
          };
        };
      };
    };
  };
}
