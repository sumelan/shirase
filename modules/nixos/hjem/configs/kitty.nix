{self, ...}: {
  flake.modules.nixos.kitty = {pkgs, ...}: let
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) kitty;
  in {
    environment.shellAliases = {
      # change color on ssh
      ssh = "kitten ssh --kitten=color_scheme='Rosé Pine Moon'";
    };

    hj.packages = [kitty];
  };
}
