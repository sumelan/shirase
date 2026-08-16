{inputs, ...}: {
  flake.custom.hjemConfigs.comview = {
    pkgs,
    user,
    ...
  }: let
    comview = inputs.comview.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    hjem.users.${user} = {
      packages = [comview];
    };
  };
}
