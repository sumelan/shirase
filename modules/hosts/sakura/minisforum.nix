_: {
  flake.modules.nixos.minisforum = _: {
    # rename audio devices
    services.pipewire.wireplumber.extraConfig = {
      "10-creative-rename" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "alsa_output.usb-Creative_Technology_Ltd_Creative_Stage_SE_mini_1120041300020421-01.analog-stereo";
              }
            ];
            actions = {
              update-props = {
                "node.description" = "Creative Stage SE mini";
              };
            };
          }
        ];
      };
      "10-ifi-rename" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "alsa_output.usb-iFi_iFi_USB_Audio_SE_iFi_USB_Audio_SE-00.analog-stereo";
              }
            ];
            actions = {
              update-props = {
                "node.description" = "iFi Audio Uno";
              };
            };
          }
        ];
      };
      "10-fifine-sink-rename" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "alsa_output.usb-FIFINE_683_Microphone_FIFINE_683_Microphone-00.analog-stereo";
              }
            ];
            actions = {
              update-props = {
                "node.description" = "FIFINE K683A Monitor";
              };
            };
          }
        ];
      };
      "10-fifine-source-rename" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "alsa_input.usb-FIFINE_683_Microphone_FIFINE_683_Microphone-00.analog-stereo";
              }
            ];
            actions = {
              update-props = {
                "node.description" = "FIFINE K683A Mic";
              };
            };
          }
        ];
      };
      "10-mic-rename" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "alsa_input.pci-0000_34_00.6.analog-stereo";
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
