{
  inputs,
  config,
  lib,
  ...
}: {
  flake.modules.nixos.default = {
    pkgs,
    user,
    ...
  }: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};

    inshellah = inputs.inshellah.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    environment.systemPackages = builtins.attrValues {
      inherit (local) nushell;
    };

    systemd.services = {
      inshellah-index = {
        description = "Indexes packages installed per-user";
        wantedBy = ["multi-user.target"];
        path = [local.nushell];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${lib.getExe inshellah} index /etc/profiles/per-user/${user}";
          User = "root";
        };
      };
    };

    programs.inshellah = {
      enable = true;
      nushellPackage = local.nushell;
    };
  };
}
