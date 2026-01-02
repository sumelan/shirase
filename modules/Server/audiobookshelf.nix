_: {
  flake.modules.nixos.audiobookshelf = {
    services.audiobookshelf = {
      enable = true;
      host = "0.0.0.0"; # "127.0.0.1" means localhost only
      port = 8234;
      openFirewall = true;
    };

    custom.persist.root.directories = [
      "/var/lib/audiobookshelf"
    ];
  };
}
