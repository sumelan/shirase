{
  self,
  config,
  pkgs,
  ...
}: let
  wrappedNushell = self.packages.${pkgs.stdenv.hostPlatform.system}.nushell.override {
    env = {
      STARSHIP_CONFIG = self.packages.${pkgs.stdenv.hostPlatform.system}.starship.starshipConfig;
    };
  };
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
