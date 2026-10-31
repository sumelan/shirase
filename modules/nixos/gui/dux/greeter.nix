{config, ...}: {
  services.displayManager.dux-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = config.hjem.users.sumelan.directory;
  };
}
