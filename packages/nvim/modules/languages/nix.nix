{
  self,
  pkgs,
  hostName,
  flake,
  ...
}: {
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

    lsp.servers.nixd = pkgs.lib.mkIf (flake != null) {
      settings.nixd = let
        inputs =
          # nix
          ''(removeAttrs (import "${self}/.tack") ["" "__functor"])'';

        myFlake =
          # nix
          ''(builtins.getFlake "${flake}")'';
      in {
        nixpkgs.expr =
          # nix
          ''import ${inputs}.nixpkgs { }'';
        options = {
          nixos.expr =
            # nix
            ''${myFlake}.nixosConfigurations.${hostName}.options'';
        };
      };
    };
  };
}
