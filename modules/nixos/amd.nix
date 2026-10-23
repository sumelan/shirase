{
  config,
  pkgs,
  ...
}: let
  inherit
    (pkgs.lib)
    mkMerge
    mkIf
    versionOlder
    versionAtLeast
    ;
  kver = config.boot.kernelPackages.kernel.version;
in {
  # cpu
  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
  # Enables the amd cpu scaling https://www.kernel.org/doc/html/latest/admin-guide/pm/amd-pstate.html
  # On recent AMD CPUs this can be more energy efficient.
  boot = mkMerge [
    (mkIf ((versionAtLeast kver "5.17") && (versionOlder kver "6.1")) {
      kernelParams = ["initcall_blacklist=acpi_cpufreq_init"];
      kernelModules = ["amd-pstate"];
    })
    (mkIf ((versionAtLeast kver "6.1") && (versionOlder kver "6.3")) {
      kernelParams = ["amd_pstate=passive"];
    })
    (mkIf (versionAtLeast kver "6.3") {
      kernelParams = ["amd_pstate=active"];
    })
  ];

  # gpu
  services = {
    xserver.videoDrivers = ["modesetting"];
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    amdgpu.initrd.enable = true;
  };
}
