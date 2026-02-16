{config, ...}: let
  inherit (config.flake.lib.wireplumber) rename;
in {
  flake.modules.nixos.chuwi-minibook-x = _: {
    hardware.chuwi-minibook-x = {
      tabletMode.enable = true;
      autoDisplayRotation = {
        enable = true;
        commands = {
          normal = ''niri msg output "DSI-1" transform 90'';
          rightUp = ''niri msg output "DSI-1" transform normal'';
          bottomUp = ''niri msg output "DSI-1" transform 270'';
          leftUp = ''niri msg output "DSI-1" transform 180'';
        };
      };
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
