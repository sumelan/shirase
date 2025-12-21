{
  pkgs,
  user,
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
      # disable camera to save battery
      # https://reddit.com/r/linux/comments/1em8biv/psa_pipewire_has_been_halving_your_battery_life/
      extraConfig = {
        "10-disable-camera" = {
          "wireplumber.profiles" = {
            main."monitor.libcamera" = "disabled";
          };
        };
        "10-alsa-soft-mixer"."monitor.alsa.rules" = [
          {
            matches = [
              {
                device.name = "alsa_output.usb-Creative_Technology_Ltd_Creative_Stage_SE_mini_1120041300020421-01.analog-stereo";
              }
            ];
            actions = {
              update-props = {
                # Do not use the hardware mixer for volume control
                # It will only use software volume.
                # The mixer is still used to mute unused paths based on the selected port.
                api.alsa.soft-mixer = true;
              };
            };
          }
        ];
      };
    };
  };

  #alsa setting
  environment.systemPackages = [pkgs.alsa-utils];
  users.users.${user}.extraGroups = ["audio"];

  hm = {
    home = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          pwvucontrol
          easyeffects
          ;
      };
      file = let
        src = pkgs.fetchFromGitHub {
          owner = "JackHack96";
          repo = "EasyEffects-Presets";
          rev = "069195c4e73d5ce94a87acb45903d18e05bffdcc";
          hash = "sha256-nXVtX0ju+Ckauo0o30Y+sfNZ/wrx3HXNCK05z7dLaFc=";
        };
        outputSet = preset: {
          ".local/share/easyeffects/output/${preset}.json".source = "${src}/${preset}.json";
        };
      in
        outputSet "Advanced Auto Gain"
        // outputSet "Bass Boosted"
        // outputSet "Bass Enhancing + Perfect EQ"
        // outputSet "Boosted"
        // outputSet "Loudness+Autogain"
        // outputSet "Perfect EQ"
        // {
          ".local/share/easyeffects/irs" = {
            source = "${src}/irs";
            recursive = true;
          };
        };
    };
  };

  custom.persist = {
    root.directories = [
      "/var/lib/alsa"
    ];
    home.directories = [
      ".local/state/wireplumber"
      ".config/easyeffects/db"
      # autoload local preset per devices
      ".local/share/easyeffects/autoload"
    ];
  };
}
