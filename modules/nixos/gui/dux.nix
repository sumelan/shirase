{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) wf-recorder;
  };

  programs = {
    dux-shell = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target";
        restartIfChanged = true;
      };
      plugins = {
        quickCapture.enable = true;
        dankKDEConnect.enable = true;
        wallpaperCarousel.enable = true;
        modernClock.enable = true;
      };
    };

    dux-search = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target";
      };
    };

    dux-calendar = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target";
        restartIfChanged = true;
      };
    };

    dux-files = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target";
        restartIfChanged = true;
      };
      portal = {
        enable = true;
      };
    };
  };

  services.displayManager.dux-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = config.hjem.users.sumelan.directory;
  };
}
