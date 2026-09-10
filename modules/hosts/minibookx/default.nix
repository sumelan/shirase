{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos."hosts/minibookx" = _: {
    imports = builtins.attrValues {
      inherit (flake.modules.nixos) chuwi-minibook-x;
      inherit (flake.modules.nixos) gui;
      inherit (flake.modules.nixos) kdeconnect;
      inherit (flake.modules.nixos) sops-nix syncthing sshConfig;
    };

    networking.hostId = "56895d2b";
  };
}
