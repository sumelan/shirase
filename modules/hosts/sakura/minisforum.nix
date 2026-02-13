_: {
  flake.modules.nixos.minisforum = _: {
    # rename audio devices
    services.pipewire.wireplumber.extraConfig = {
      "10-jbl-rename" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "alsa_output.usb-Harman_International_Industries_JBL_Pebbles_1.0.0-01.analog-stereo";
              }
            ];
            actions = {
              update-props = {
                "node.description" = "JBL Pebbles";
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
