{
  user,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

  # SystemModule Options.
  custom = {
    backup = {
      enable = true;
      include = [
        "/var/lib/nextcloud"
        "/var/lib/audiobookshelf"
      ];
      exclude = [ ];
      repo = "rhq681sk@rhq681sk.repo.borgbase.com:repo";
      cycle = "daily";
    };
    agenix.enable = true;
    server = {
      audiobookshelf.enable = true;
      nextcloud.enable = true;
      nginx = {
        enable = true;
        domain = "sakurairo.ddnsfree.com";
        provider = "dynu";
      };
    };
    distrobox.enable = true;
    qmk.enable = true;
    opentabletdriver.enable = true;
    usb-audio.enable = true;
  };

  services.displayManager.autoLogin.user = user;
}
