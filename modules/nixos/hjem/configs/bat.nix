{self, ...}: {
  flake.modules.nixos.default = {pkgs, ...}: let
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) bat batman;
  in {
    programs = {
      # manually add the abbr so it doesn't get mangled by nix
      fish.interactiveShellInit =
        # fish
        ''
          abbr -a --position anywhere -- --help '--help | bat --plain --language=help'
        '';
    };

    hj.packages = [bat batman];
  };
}
