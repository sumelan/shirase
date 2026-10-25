{
  self,
  config,
  ...
}: {
  vim.lsp.servers.nixd = {
    settings.nixd = let
      inherit (config.networking) hostName;
      dotfile = "/persist/home/sumelan/Projects/shirase";

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
      };
    };
  };
}
