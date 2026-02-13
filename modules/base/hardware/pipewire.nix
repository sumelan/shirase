_: {
  flake.modules = {
    nixos.default = {
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
          };
        };
      };
      #alsa setting
      environment.systemPackages = [pkgs.alsa-utils];
      users.users.${user}.extraGroups = ["audio"];
      custom.persist = {
        root.directories = [
          "/var/lib/alsa"
        ];
        home.directories = [
          ".local/state/wireplumber"
        ];
      };
    };
    homeManager.default = {pkgs, ...}: {
      # it is necessary to add `programs.dconf.enable = true;` for the daemon to work correctly
      services.easyeffects.enable = true;
      home.packages = [pkgs.pwvucontrol];
      xdg.dataFile = let
        src = pkgs.fetchFromGitHub {
          owner = "JackHack96";
          repo = "EasyEffects-Presets";
          rev = "d77a61eb01c36e2c794bddc25423445331e99915";
          hash = "sha256-or5kH/vTwz7IO0Vz7W4zxK2ZcbL/P3sO9p5+EdcC2DA=";
        };
        output = preset: {
          "easyeffects/output/${preset}.json".source = "${src}/${preset}.json";
        };
      in
        output "Advanced Auto Gain"
        // output "Bass Boosted"
        // output "Bass Enhancing + Perfect EQ"
        // output "Boosted"
        // output "Loudness+Autogain"
        // output "Perfect EQ"
        // {
          "easyeffects/irs" = {
            source = "${src}/irs";
            recursive = true;
          };
        };

      custom.persist = {
        home.directories = [
          ".config/easyeffects/db"
          # autoload local preset per devices
          ".local/share/easyeffects/autoload"
        ];
      };
    };
  };
}
