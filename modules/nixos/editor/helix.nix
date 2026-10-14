{
  config,
  self,
  ...
}: let
  inherit (config) flake;
  inherit (flake.custom.wrappers) mkHelix;
in {
  flake.modules.nixos.default = {
    config,
    pkgs,
    dotfile,
    ...
  }: let
    inherit (config.networking) hostName;

    extraLang = {
      language-server.nixd.config.nixd = let
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
  in {
    environment = {
      systemPackages = [
        (mkHelix {inherit pkgs extraLang;})
      ];
    };

    custom.fileSystem = {
      cache.home.directories = [
        # helix log
        ".cache/helix"
      ];
    };
  };
}
