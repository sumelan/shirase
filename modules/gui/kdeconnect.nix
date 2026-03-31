_: {
  flake.modules.nixos.hjem-kdeconnect = _: {
    programs.kdeconnect = {
      enable = true;
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/kdeconnect"
      ];
      cache.home.directories = [
        ".cache/kdeconnect.app"
        ".cache/kdeconnect.daemon"
      ];
    };
  };
}
