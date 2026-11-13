_: {
  networking.hostId = "8425e349";
  services.openssh.settings.PermitRootLogin = "prohibit-password";

  custom = {
    programs = {
      btop.rocmSupport = true;
    };

    openssh.authorizedKeys.extraKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEccK/BVlzlTuJJF+oU1pEWVehQSmTUVYbi1jNQrvLo8 syncoid@omen"
    ];

    hardware.hdds = {
      westernDigital = true;
      ironWolf = true;
    };
  };
}
