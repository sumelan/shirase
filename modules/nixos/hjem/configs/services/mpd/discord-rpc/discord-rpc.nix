{lib, ...}: {
  flake.modules.nixos.discord-rpc = {
    config,
    pkgs,
    ...
  }: {
    hj.systemd.services = {
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

    hj.xdg.config.files."discord-rpc/config.toml" = {
      generator = (pkgs.formats.toml {}).generate "config.toml";
      value = import ./_config.nix {inherit config;};
    };
  };
}
