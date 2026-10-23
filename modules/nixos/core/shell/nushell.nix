{
  self,
  config,
  pkgs,
  ...
}: let
  wrappedNushell = self.packages.${pkgs.stdenv.hostPlatform.system}.nushell.override {
    env = {
      STARSHIP_CONFIG = import (self + "/packages/wrapped/starship/_config.nix") {inherit pkgs;};
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
