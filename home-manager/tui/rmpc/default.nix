{ pkgs, user, ... }:
{
  home = {
    packages = with pkgs; [ rmpc ];
    file = {
      ".config/rmpc/config.ron" = {
        source = ./config.ron;
      };
      ".config/rmpc/themes/custom.ron" = {
        source = ./theme.ron;
      };
      ".config/rmpc/notify" = {
        source = ./notify.fish;
        executable = true;
      };
    };
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
