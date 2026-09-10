{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos."hosts/acer" = _: {
    imports = builtins.attrValues {
      inherit (flake.modules.nixos) acer-al14;
      inherit (flake.modules.nixos) gui;
      inherit (flake.modules.nixos) kdeconnect;
      inherit (flake.modules.nixos) sops-nix sshConfig;
    };

    networking.hostId = "22fe2870";
  };
}
