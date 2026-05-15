{lib, ...}: {
  flake.modules.nixos.pipewire = {pkgs, ...}: {
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
            ExecStartPre = lib.getExe' pkgs.coreutils "sleep 5s";
            ExecStart = lib.getExe' pkgs.easyeffects "easyeffects --hide-window";
            ExecStop = lib.getExe' pkgs.easyeffects "easyeffects --quit";
            KillMode = "mixed";
            Restart = "on-failure";
            RestartSec = 5;
            TimeoutStopSec = 10;
          };
        };

        # mpris user service to control media player over bluetooth
        mpris-proxy = {
          description = "Proxy forwarding Bluetooth MIDI controls via MPRIS2 to control media players";
          bindsTo = ["bluetooth.target"];
          after = ["bluetooth.target"];
          wantedBy = ["bluetooth.target"];

          serviceConfig = {
            Type = "simple";
            ExecStart = lib.getExe' pkgs.bluez "mpris-proxy";
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
}
