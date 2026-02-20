{config, ...}: let
  inherit (config.flake.lib.wireplumber) rename;
in {
  flake.modules.nixos.chuwi-minibook-x = _: {
    services.iio-niri = {
      enable = true;
      extraArgs = ["--monitor" "DSI-1" "--transform" "90" "180" "270" "normal"];
    };

    # rotate limine interface
    boot.loader.limine.extraConfig = ''
      interface_rotation: 90
    '';

    # rename audio devices
    services.pipewire.wireplumber.extraConfig = {
      "10-speaker-rename" = rename "alsa_output.pci-0000_00_1f.3.analog-stereo" "Built-in Speakers";
      "10-dac-rename" = rename "alsa_output.usb-TTGK_Technology_Co._Ltd_NICEHCK_NK1_MAX-00.analog-stereo" "NICEHCK NK1 MAX";
      "10-input-rename" = rename "alsa_input.pci-0000_00_1f.3.analog-stereo" "Built-in Mic";
    };
  };
}
