{lib, ...}: {
  flake.custom.hjemModules.discord-rpc = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.services.mpd-discord-rpc;
    tomlFmt = pkgs.formats.toml {};
  in {
    options.rum = {
      services.mpd-discord-rpc = {
        enable = lib.mkEnableOption "the mpd-discord-rpc service";

        settings = lib.mkOption {
          inherit (tomlFmt) type;
          default = {};
          description = ''
            Configuration included in `config.toml`.
            For available options see <https://github.com/JakeStanger/mpd-discord-rpc#configuration>
          '';
        };
      };
    };

    config = lib.mkIf cfg.enable {
      systemd.services = {
        mpd-discord-rpc = {
          description = "Discord Rich Presence for MPD";
          documentation = ["https://github.com/JakeStanger/mpd-discord-rpc"];
          after = ["graphical-session.target"];
          partOf = ["graphical-session.target"];
          wantedBy = ["graphical-session.target"];

          serviceConfig = {
            ExecStart = lib.getExe pkgs.mpd-discord-rpc;
            Restart = "on-failure";
          };
        };
      };

      xdg.config.files."discord-rpc/config.toml" = {
        generator = tomlFmt.generate "config.toml";
        value = cfg.settings;
      };
    };
  };
}
