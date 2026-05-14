_: {
  flake.modules.nixos = {
    pipewire = {
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
  };
}
