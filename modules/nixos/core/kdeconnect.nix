_: {
  flake.modules.nixos.kdeconnect = {pkgs, ...}: {
    programs.kdeconnect = {
      enable = true;
      package = pkgs.valent;
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/valent"
      ];
      cache.home.directories = [
        ".cache/valent"
      ];
    };
  };
}
