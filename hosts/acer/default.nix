{
  pkgs,
  inputs,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-cpu-intel
  ];

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  services = {
    # power management
    power-profiles-daemon.enable = true;
    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };
    tlp.settings = {
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
    };

    # touchpad support
    libinput.enable = true;
  };

  # SystemModule Options
  custom = {
    btrbk = {
      enable = true;
      relationShip = "client";
    };
    distrobox.enable = true;
  };
}
