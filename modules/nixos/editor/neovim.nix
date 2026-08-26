{config, ...}: {
  flake.modules.nixos.default = {pkgs, ...}: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    environment.systemPackages = builtins.attrValues {
      inherit (local) nvf;
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".supermaven"
        ".local/share/nvim" # data directory
        ".local/state/nvim" # persistent session info
        ".local/share/supermaven"
      ];
    };
  };
}
