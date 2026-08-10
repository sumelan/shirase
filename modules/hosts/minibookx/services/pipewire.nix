_: {
  flake.modules.nixos."hosts/minibookx" = {flakeLib, ...}: {
    services.pipewire = {
      extraConfig = {
        # [info] pipewire locks to 48 kHz as default
        pipewire = {
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

        client = {
          # QBZ DAC Setup - Per-App Bit-Perfect
          "99-qbz-bitperfect" = {
            "stream.rules" = [
              {
                matches = [
                  {"application.process.binary" = "qbz";}
                  {"application.name" = "PipeWire ALSA [qbz]";}
                ];
                actions = {
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

      wireplumber.extraConfig = let
        inherit (flakeLib.wireplumber {}) rename;
      in {
        # QBZ DAC Setup - NICEHCK NK1 MAX
        "99-qbz-dac-nicehck-nk1-max" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "node.name" = "alsa_output.usb-TTGK_Technology_Co._Ltd_NICEHCK_NK1_MAX-00.analog-stereo";
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
        "10-speaker-rename" = rename {
          old = "alsa_output.pci-0000_00_1f.3.analog-stereo";
          new = "Built-in Speakers";
        };
        "10-input-rename" = rename {
          old = "alsa_input.pci-0000_00_1f.3.analog-stereo";
          new = "Built-in Mic";
        };
        "10-nicehck-rename" = rename {
          old = "alsa_output.usb-TTGK_Technology_Co._Ltd_NICEHCK_NK1_MAX-00.analog-stereo";
          new = "NICEHCK NK1 MAX";
        };
      };
    };
  };
}
