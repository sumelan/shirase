{lib, ...}: {
  flake.custom.hjemConfigs.niri = {
    config,
    pkgs,
    dotfile,
    ...
  }: {
    hj.rum = {
      programs.niri = {
        inherit (config.programs.niri) package;
        settings = import ./_config.nix {inherit config lib pkgs dotfile;};
      };
    };
  };
}
