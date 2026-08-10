_: {
  flake.modules.nixos."hosts/sakura" = {flakeLib, ...}: {
    services.pipewire = {
      extraConfig = {
        # [info] pipewire locks to 48 kHz as default
        "pipewire" = {
          # QDC DAC Setup - Sample Rate Switching
          "99-qbz-dac" = {
            "context.properties" = {
              "default.clock.allowed-rates" = [
                44100
                48000
                88200
                96000
                176400
                192000
              ];
            };
          };
        };

        "client" = {
          # QBZ DAC Setup - Per-App Bit-Perfect
          "99-qbz-bitperfect" = {
            "stream.rules" = [
              {
                matches = [
                  {"application.process.binary" = "qbz";}
                  {"application.name" = "PipeWire ALSA [qbz]";}
                ];
                actions = {
                  update-props = {
                    "resample.disable" = true;
                    "channelmix.disable" = true;
                  };
                };
              }
            ];
          };
        };
      };

      wireplumber.extraConfig = let
        inherit (flakeLib.wireplumber {}) rename;
      in {
        # QBZ DAC Setup - iFi Audio Uno
        "99-qbz-dac-ifi-audio-uno" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "node.name" = "alsa_output.usb-iFi_iFi_USB_Audio_SE_iFi_USB_Audio_SE-00.analog-stereo";
                  "media.class" = "Audio/Sink";
                }
              ];
              actions = {
                "update-props" = {
                  "audio.allowed-rates" = [44100 48000 88200 96000 176400 192000];
                  "resample.disable" = true;
                  "channelmix.disable" = true;
                };
              };
            }
          ];
        };

        "99-qbz-dac-shanling-h0" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "node.name" = "alsa_output.usb-Shanling_Shanling_H0-00.analog-stereo";
                  "media.class" = "Audio/Sink";
                }
              ];
              actions = {
                "update-props" = {
                  "audio.allowed-rates" = [44100 48000 88200 96000 176400 192000];
                  "resample.disable" = true;
                  "channelmix.disable" = true;
                };
              };
            }
          ];
        };

        # Rename ALSA devices
        "10-mic-rename" = rename {
          old = "alsa_input.pci-0000_34_00.6.analog-stereo";
          new = "Built-in Mic";
        };
        "10-creative-rename" = rename {
          old = "alsa_output.usb-Creative_Technology_Ltd_Creative_Stage_SE_mini_1120041300020421-01.analog-stereo";
          new = "Creative Stage SE mini";
        };
        "10-ifi-rename" = rename {
          old = "alsa_output.usb-iFi_iFi_USB_Audio_SE_iFi_USB_Audio_SE-00.analog-stereo";
          new = "iFi Audio Uno";
        };
        "10-shanling-rename" = rename {
          old = "alsa_output.usb-Shanling_Shanling_H0-00.analog-stereo";
          new = "Shanling H0";
        };
        "10-fifine-sink-rename" = rename {
          old = "alsa_output.usb-FIFINE_683_Microphone_FIFINE_683_Microphone-00.analog-stereo";
          new = "FIFINE K683A Monitor";
        };
        "10-fifine-source-rename" = rename {
          old = "alsa_input.usb-FIFINE_683_Microphone_FIFINE_683_Microphone-00.analog-stereo";
          new = "FIFINE K683A Mic";
        };
      };
    };
  };
}
