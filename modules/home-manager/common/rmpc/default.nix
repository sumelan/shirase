_: {
  imports = [
    ./config.nix
    ./theme.nix
  ];

  programs.rmpc.enable = true;

  custom.persist = {
    home.cache.directories = [
      ".cache/rmpc/youtube"
    ];
  };
}
