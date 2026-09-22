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
      systemPackages = [local.nushell];
      etc = {
        "nushell/config.nu".source = flake.custom.wrappers.mkNuConfig {inherit pkgs;};
        "nushell/env.nu".source = flake.custom.wrappers.mkNuEnvConfig {inherit pkgs;};
        "nushell/inshellah.nu".text = config.programs.inshellah.snippet;
      };
      shells = [
        "/run/current-system/sw/bin/nu"
        "${local.nushell}/bin/nu"
      ];
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
