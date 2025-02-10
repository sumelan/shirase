_:{
  networking.hostId = "b0e5d98e";

  # SystemModule Options.
  custom = {
    backup = {
      enable = false;
      include = [
        "/var/lib/nextcloud"
        "/var/lib/audiobookshelf"
      ];
      exclude = [ ];
      repo = "rhq681sk@rhq681sk.repo.borgbase.com:repo";
      cycle = "daily";
    };
    agenix.enable = true;
    audiobookshelf.enable = false;
    nextcloud.enable = false;
    nginx = {
      enable = false;
      domain = "sakurairo.ddnsfree.com";
      provider = "dynu";
    };
    distrobox.enable = true;
    qmk.enable = true;
    opentabletdriver.enable = true;
    usb-audio.enable = true;
  };
}
