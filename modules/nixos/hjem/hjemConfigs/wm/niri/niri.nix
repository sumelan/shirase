{lib, ...}: {
  flake.custom.hjemConfigs.niri = {
    config,
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user}.rum = {
      wayland.windowManager.niri = {
        enable = true;
        inherit (config.programs.niri) package;
        settings = import ./_config.nix {inherit config lib pkgs user;};
      };
    };
  };
}
