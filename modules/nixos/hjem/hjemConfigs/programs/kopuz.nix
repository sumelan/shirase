{inputs, ...}: {
  flake.custom.hjemConfigs.kopuz = {
    pkgs,
    user,
    ...
  }: let
    kopuzPkg = inputs.kopuz.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    hjem.users.${user} = {
      packages = [kopuzPkg];
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/kopuz"
      ];

      cache.home.directories = [
        ".cache/kopuz"
        ".local/share/kopuz"
      ];
    };
  };
}
