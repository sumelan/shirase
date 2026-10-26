{
  self,
  config,
  pkgs,
  ...
}: let
  wrappedNushell = self.packages.${pkgs.stdenv.hostPlatform.system}.nushell;
in {
  environment = {
    systemPackages = [wrappedNushell];

    etc = {
      "nushell/inshellah.nu".text = config.programs.inshellah.snippet;
    };

    shells = [
      "/run/current-system/sw/bin/nu"
      "${wrappedNushell}/bin/nu"
    ];
  };

  programs.inshellah = {
    enable = true;
    nushellPackage = wrappedNushell;
  };
}
