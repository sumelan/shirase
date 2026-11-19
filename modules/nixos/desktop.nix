{functions, ...}: let
  inherit (functions.import) tree;
in {
  imports = [
    ./hardware/audio.nix
    ./hardware/bluetooth.nix
    ./hardware/kdeconnect.nix

    (tree ./gui)
    ./hjem/gui.nix
  ];
}
