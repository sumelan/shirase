{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.custom.usb-audio;
in
{
  options.custom.usb-audio = {
    enable = mkEnableOption "Enable using usb-audio";
  };

  config = mkIf cfg.enable {
    services.pipewire.extraConfig = {
      pipewire = {
        "10-clock-rate" = {
          "context.properties" = {
            "default.clock.allowed-rates" = [
              44100
              48000
              88200
              96000
              176400
              192000 # spotify refuses to play when above 192 kHz.
              352800
              384000
            ];
          };
        };
        "98-jbl-pebbles" = {
          "device.rules" = [
            {
              matches = [
                { "device.name" = "alsa_card.usb-Harman_International_Industries_JBL_Pebbles_1.0.0-01"; }
              ];
              actions = {
                update-props = {
                  "alsa.format" = "S16_LE";
                  "audio.format" = "S16LE";
                };
              };
            }
          ];
        };
        "98-ifi-audio-uno" = {
          "device.rules" = [
            {
              matches = [
                { "device.name" = "alsa_card.usb-SXW_iFi_USB_Audio_SE_iFi_USB_Audio_SE-00"; }
              ];
              actions = {
                update-props = {
                  "alsa.format" = "S32_LE";
                  "audio.format" = "SE32LE";
                };
              };
            }
          ];
        };
      };
      client = {
        "10-no-resampling" = {
          "stream.properties" = {
            "resample.disable" = true;
          };
        };
      };
      client-rt = {
        "10-no-resampling" = {
          "stream.properties" = {
            "resample.disable" = true;
          };
        };
      };
      pipewire-pulse = {
        "10-no-resampling" = {
          "stream.properties" = {
            "resample.disable" = true;
          };
        };
      };
    };
  };
}
