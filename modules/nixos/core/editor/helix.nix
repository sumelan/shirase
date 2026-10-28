{
  self,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    (
      self.packages.${pkgs.stdenv.hostPlatform.system}.helix.override {
        inherit (config.networking) hostName;
        flake = "/persist/home/sumelan/Projects/shirase";
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
