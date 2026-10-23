_: {
  networking.hostId = "8425e349";

  custom = {
    programs = {
      btop.rocmSupport = true;
    };

    hardware.hdds = {
      westernDigital = true;
      ironWolf = true;
    };
  };
}
