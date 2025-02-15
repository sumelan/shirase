{
  config,
  pkgs,
  user,
  ...
}:
{
  # setup pipewire for audio
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # disable camera to save battery
      # https://reddit.com/r/linux/comments/1em8biv/psa_pipewire_has_been_halving_your_battery_life/
      wireplumber = {
        enable = true;
        extraConfig = {
          "10-disable-camera" = {
              "wireplumber.profiles" = {
                main."monitor.libcamera" = "disabled";
              };
            };
        };
      };
    };
    pulseaudio.enable = false;

    mpd = {
      enable = true;
      user = "${user}";
      musicDirectory = "/home/${user}/Music";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };
  };
  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    # User-id must match above user. MPD will look inside this directory
    # for the PipeWire socket.
    XDG_RUNTIME_DIR = "/run/user/${builtins.toString config.users.users.${user}.uid}";
  };

  environment.systemPackages = with pkgs; [ pwvucontrol ];
}
