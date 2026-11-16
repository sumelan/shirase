{
  self,
  inputs,
  pkgs,
  ...
}: let
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) nushell;
  inshellah = inputs.inshellah.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  system.userActivationScripts = {
    inshellah-index.text =
      # sh
      ''
        profile=/etc/profiles/per-user/sumelan
        if [ -e "$profile" ]; then
          PATH="${nushell}/bin:$PATH" \
            ${inshellah}/bin/inshellah index "$profile"
        fi
      '';
  };

  custom.fileSystem = {
    persist.home.directories = [
      ".config/nushell"
    ];
  };
}
