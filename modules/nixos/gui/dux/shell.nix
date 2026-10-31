{pkgs, ...}: {
  programs.dux-shell = {
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

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) wf-recorder;
  };
}
