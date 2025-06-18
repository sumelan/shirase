{ pkgs, ... }:
{
  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig = {
        pipewire = {
          # automatically switch to newly connected devices
          switch-on-connect = {
            "pulse.cmd" = [
              {
                cmd = "load-module";
                args = [ "module-switch-on-connect" ];
              }
            ];
          };
        };
      };
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
  };
  hm = {
    home.packages = with pkgs; [ pwvucontrol ];
    programs.niri.settings.window-rules = [
      {
        matches = [ { app-id = "^(com.saivert.pwvucontrol)$"; } ];
        open-floating = true;
        default-column-width.proportion = 0.4;
        default-window-height.proportion = 0.4;
      }
    ];
  };
  custom.persist = {
    home.directories = [
      ".local/state/wireplumber"
    ];
  };
}
