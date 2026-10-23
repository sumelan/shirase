{inputs, ...}: {
  imports =
    [
      ./hardware/audio.nix
      ./hardware/bluetooth.nix
      ./hardware/kdeconnect.nix
      (inputs.import-tree ./gui)
      ./hjem/gui.nix
    ]
    ++ [
      ./hardware/keyd.nix
      ./hardware/wifi.nix
    ];

  # disbale USB after sometime of inactivity
  powerManagement.powertop.enable = true;

  services.libinput.enable = true;
}
