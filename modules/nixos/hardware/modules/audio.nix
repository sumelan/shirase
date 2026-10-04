_: {
  flake.modules.nixos.audio = {
    pkgs,
    user,
    flakeLib,
    ...
  }: {
    # allows Pipewire to use the realtime scheduler for increased performance
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber = {
        enable = true;
        extraConfig = let
          inherit (flakeLib.wireplumber {}) rename;
        in {
          # disable camera to save battery
          # https://reddit.com/r/linux/comments/1em8biv/psa_pipewire_has_been_halving_your_battery_life/
          "10-disable-camera" = {
            "wireplumber.profiles" = {
              "main.monitor.libcamera" = "disabled";
            };
          };
          # ALSA rename
          "10-ifi-rename" = rename {
            old = "alsa_output.usb-iFi_iFi_USB_Audio_SE_iFi_USB_Audio_SE-00.analog-stereo";
            new = "iFi Audio Uno";
          };
          "10-shanling-rename" = rename {
            old = "alsa_output.usb-Shanling_Shanling_H0-00.analog-stereo";
            new = "Shanling H0";
          };
          "10-nicehck-rename" = rename {
            old = "alsa_output.usb-TTGK_Technology_Co._Ltd_NICEHCK_NK1_MAX-00.analog-stereo";
            new = "NICEHCK NK1 MAX";
          };
          "10-fifine-sink-rename" = rename {
            old = "alsa_output.usb-FIFINE_683_Microphone_FIFINE_683_Microphone-00.analog-stereo";
            new = "FIFINE K683A Monitor";
          };
          "10-fifine-source-rename" = rename {
            old = "alsa_input.usb-FIFINE_683_Microphone_FIFINE_683_Microphone-00.analog-stereo";
            new = "FIFINE K683A Mic";
          };
          "10-creative-rename" = rename {
            old = "alsa_output.usb-Creative_Technology_Ltd_Creative_Stage_SE_mini_1120041300020421-01.analog-stereo";
            new = "Creative Stage SE mini";
          };
        };
      };
    };

    #alsa setting
    environment.systemPackages = [pkgs.alsa-utils];
    users.users.${user}.extraGroups = ["audio"];

    custom.fileSystem = {
      persist = {
        root.directories = [
          "/var/lib/alsa"
        ];
        home.directories = [
          ".local/state/wireplumber"
        ];
      };
    };
  };
}
