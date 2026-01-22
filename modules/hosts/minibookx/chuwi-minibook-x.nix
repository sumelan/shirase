_: {
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
      "10-output-rename" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "alsa_output.pci-0000_00_1f.3.analog-stereo";
              }
            ];
            actions = {
              update-props = {
                "node.description" = "Built-in Speakers";
              };
            };
          }
        ];
      };
      "10-input-rename" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "alsa_input.pci-0000_00_1f.3.analog-stereo";
              }
            ];
            actions = {
              update-props = {
                "node.description" = "Built-in Mic";
              };
            };
          }
        ];
      };
    };
  };
}
