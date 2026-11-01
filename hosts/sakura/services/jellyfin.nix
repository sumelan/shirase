_: {
  services.jellyfin = {
    hardwareAcceleration = {
      enable = true;
      device = "/dev/dri/by-path/pci-0000:34:00.0-render";
    };
  };
}
