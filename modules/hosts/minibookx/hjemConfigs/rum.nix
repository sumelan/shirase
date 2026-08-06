{inputs, ...}: {
  flake.modules.nixos."hosts/minibookx" = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user}.rum = {
      programs.qbz.package = inputs.qbz.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}
