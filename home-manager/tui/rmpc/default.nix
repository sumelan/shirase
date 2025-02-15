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
    dataDir = "/home/${user}/.config/mpd";
    dbFile = "/home/${user}/.config/mpd/tag_cache";
    extraConfig = ''
      bind_to_address	"/home/sumelan/.config/mpd/mpd_socket"
    '';
  };

  custom.persist = {
    home.directories = [
      # yt-dlp cache
      ".cache/rmpc"
    ];
  };
}
