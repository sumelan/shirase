{
  self,
  config,
  pkgs,
  ...
}: let
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) nushell;
in {
  environment = {
    systemPackages = [nushell];

    etc = {
      "nushell/inshellah.nu".text = config.programs.inshellah.snippet;
    };

    shells = [
      "/run/current-system/sw/bin/nu"
      "${nushell}/bin/nu"
    ];
  };

  programs.inshellah = {
    enable = true;
    nushellPackage = nushell;
  };
}
