{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.modules.nixos.default = {
    config,
    pkgs,
    user,
    ...
  }: let
    local = flake.packages.${pkgs.stdenv.hostPlatform.system};
    inshellah = inputs.inshellah.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    environment = {
      systemPackages = builtins.attrValues {
        inherit (local) nushell;
      };
      etc."nushell/inshellah.nu".text = config.programs.inshellah.snippet;
    };

    systemd.services = {
      inshellah-index = {
        description = "Indexes packages installed per-user";
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        path = [local.nushell];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${lib.getExe inshellah} index /etc/profiles/per-user/${user}";
        };
      };
    };

    programs.inshellah = {
      enable = true;
      nushellPackage = local.nushell;
    };
  };
}
