_: {
  imports = [
    ./hardware/hdds.nix

    ./services/audiobookshelf.nix
    ./services/borgmatic.nix
    ./services/jellyfin.nix
    ./services/syncoid.nix

    ./hjem/mini.nix
  ];
}
