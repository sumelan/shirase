_: {
  flake.modules.nixos.kdeconnect = {pkgs, ...}: {
    programs.kdeconnect = {
      enable = true;
      package = pkgs.valent; # kde-connect, but built with gtk
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
