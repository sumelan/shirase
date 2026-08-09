_: {
  flake.modules.nixos."hosts/sakura" = _: {
    services.pipewire = {
      extraConfig = {
        # [info] pipewire locks to 48 kHz as default
        pipewire = {
          "99-qbz-dac-ifi-audio-uno" = {
            # QDC DAC Setup - Sample Rate Switching
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

        client = {
          "99-qbz-bitperfect-ifi-audio-uno" = {
            # QBZ DAC Setup - Per-App Bit-Perfect
            "stream.rules" = [
              {
                "matches" = [
                  {"application.process.binary" = "qbz";}
                  {"application.name" = "PipeWire ALSA [qbz]";}
                ];
                "actions" = {
                  "update-props" = {
                    "resample.disable" = true;
                    "channelmix.disable" = true;
                  };
                };
              }
            ];
          };
        };
      };

      wireplumber.extraConfig = {
        "99-qbz-dac-ifi-audio-uno" = {
          # QBZ DAC Setup - iFi Audio Uno
          "monitor.alsa.rules" = [
            {
              "matches" = [
                {
                  "node.name" = "alsa_output.usb-iFi_iFi_USB_Audio_SE_iFi_USB_Audio_SE-00.analog-stereo";
                  "media.class" = "Audio/Sink";
                }
              ];
              "actions" = {
                "update-props" = {
                  "audio.allowed-rates" = [44100 48000 88200 96000 176400 192000];
                  "resample.disable" = true;
                  "channelmix.disable" = true;
                };
              };
            }
          ];
        };
      };
    };
  };
}
