{config, ...}: {
  flake.modules.nixos.default = {pkgs, ...}: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    environment.systemPackages = builtins.attrValues {
      inherit (local) nvf;
    };
  };
}
