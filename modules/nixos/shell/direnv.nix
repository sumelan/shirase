_: {
  flake.modules.nixos.default = {pkgs, ...}: {
    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };

    environment.systemPackages = [
      pkgs.direnv
    ];

    custom.fileSystem = {
      persist.home.directories = [
        ".local/share/direnv"
      ];
      cache.home.directories = [
        # python package managers
        ".cache/pip"
        ".cache/uv"
      ];
    };
  };
}
