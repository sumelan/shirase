{lib, ...}: {
  flake.custom.hjemModules.pipewire = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.services.easyeffects;
  in {
    options.rum = {
      services.easyeffects = {
        enable = lib.mkEnableOption "Easyeffects daemon";

        presets = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Add easyeffects presets from a repo.
            See <https://github.com/JackHack96/EasyEffects-Presets>.
          '';
        };
      };
    };

    config = lib.mkIf cfg.enable {
      packages = [pkgs.easyeffects];

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
      };

      xdg.data =
        lib.mkIf cfg.presets
        {
          files = let
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
    };
  };
}
