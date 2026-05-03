{lib, ...}: let
  inherit (lib) getExe';
in {
  flake.modules.nixos = {
    common = {
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

    gui = {pkgs, ...}: {
      hj = {
        packages = [
          pkgs.pwvucontrol
          pkgs.easyeffects
        ];

        systemd.services = {
          easyeffects = {
            description = "Easyeffects daemon";
            after = ["graphical-session.target"] ++ ["tray.target"];
            partOf = ["graphical-session.target"];
            wantedBy = ["graphical-session.target"];

            serviceConfig = {
              # avoid to race comditions
              ExecStartPre = getExe' pkgs.coreutils "sleep 5s";
              ExecStart = getExe' pkgs.easyeffects "easyeffects --hide-window";
              ExecStop = getExe' pkgs.easyeffects "easyeffects --quit";
              KillMode = "mixed";
              Restart = "on-failure";
              RestartSec = 5;
              TimeoutStopSec = 10;
            };
          };
        };

        xdg.data.files = let
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
            "easyeffects/irs".source = "${src}/irs";
          };
      };

      custom.fileSystem = {
        persist.home.directories = [
          ".config/easyeffects/db"
          # autoload local preset per devices
          ".local/share/easyeffects/autoload"
        ];
      };
    };
  };
}
