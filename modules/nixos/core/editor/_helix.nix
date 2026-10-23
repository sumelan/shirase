{
  self,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = let
    inherit (config.networking) hostName;
    dotfile = "/persist/home/sumelan/Projects/shirase";
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
        };
      };
    };
  in [
    self.packages.${pkgs.stdenv.hostPlatform.system}.helix.override
    {inherit extraLang;}
  ];

  custom.fileSystem = {
    cache.home.directories = [
      # helix log
      ".cache/helix"
    ];
  };
}
