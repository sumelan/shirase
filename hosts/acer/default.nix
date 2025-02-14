{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];

  networking.hostId = "";

  # Laptop Modules.
  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    cpupower-gui
    glib # for cpupower-gui.desktop to work.
    powertop
  ];
  services = {
    power-profiles-daemon.enable = true;
    cpupower-gui.enable = true;
    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 8;
      percentageAction = 5;
      criticalPowerAction = "PowerOff";
    };
    tlp.settings = {
      CPU_ENERGY_PERF_POLICY_ON_AC = "power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 1;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "power";

      INTEL_GPU_MIN_FREQ_ON_AC = 500;
      INTEL_GPU_MIN_FREQ_ON_BAT = 500;
      # INTEL_GPU_MAX_FREQ_ON_AC=0;
      # INTEL_GPU_MAX_FREQ_ON_BAT=0;
      # INTEL_GPU_BOOST_FREQ_ON_AC=0;
      # INTEL_GPU_BOOST_FREQ_ON_BAT=0;

      # PCIE_ASPM_ON_AC = "default";
      # PCIE_ASPM_ON_BAT = "powersupersave";
    };

    # larger runtime directory size to not run out of ram while building
    # https://discourse.nixos.org/t/run-usr-id-is-too-small/4842
    logind.extraConfig = "RuntimeDirectorySize=3G";

    # touchpad support
    libinput.enable = true;
  };

  powerManagement.cpuFreqGovernor = "performance";
  boot = {
    kernelModules = [ "acpi_call" ];
    extraModulePackages =
      with config.boot.kernelPackages;
      [
        acpi_call
        cpupower
      ]
      ++ [ pkgs.cpupower-gui ];
  };

  # SystemModule Options
  custom = {
    distrobox.enable = true;
  };
}
