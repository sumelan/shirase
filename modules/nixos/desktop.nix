{inputs, ...}: {
  imports = [
    ./hardware/audio.nix
    ./hardware/bluetooth.nix
    ./hardware/kdeconnect.nix

    (inputs.import-tree ./gui)
    ./hjem/gui.nix
  ];
}
