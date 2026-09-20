{config, ...}: {
  flake.modules.nixos."hosts/omen" = _: {
    imports = builtins.attrValues {
      inherit
        (config.flake.modules.nixos)
        gui
        kdeconnect
        #       nix-secrets
        ;
    };

    networking.hostId = "448a3092"; # FIXME:
  };
}
