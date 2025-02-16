{ pkgs, user, ... }:
{
  imports = [
    ./config.nix
    ./theme.nix
  ];

  home.packages = with pkgs; [ rmpc ];

  xdg.configFile."rmpc/notify" = {
    source = ./notify.fish;
    executable = true;
  };

  services.mpd = {
    enable = true;
    musicDirectory = "/home/${user}/Music";
    dataDir = "/home/${user}/.config/mpd";
    dbFile = "/home/${user}/.config/mpd/tag_cache";
    extraConfig = ''
      audio_output {
        type            "pipewire"
        name            "PipeWire Sound Server"
      }
      bind_to_address	"/home/${user}/.config/mpd/mpd_socket"
    '';
  };

  custom.persist = {
    home.directories = [
      ".config/mpd"
      # yt-dlp cache
      ".cache/rmpc"
    ];
  };
}
