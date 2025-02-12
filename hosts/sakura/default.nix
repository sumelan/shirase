{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

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
    agenix.enable = false;
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
  };
}
