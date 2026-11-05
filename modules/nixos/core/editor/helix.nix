{
  self,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    (
      self.packages.${pkgs.stdenv.hostPlatform.system}.helix.override {
        extraLang = {
          language-server.nixd.config.nixd = let
            inherit (config.networking) hostName;
            flake = "/persist/home/sumelan/Projects/shirase";

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
      }
    )
  ];

  custom.fileSystem = {
    cache.home.directories = [
      # helix log
      ".cache/helix"
    ];
  };
}
