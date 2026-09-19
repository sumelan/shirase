{config, ...}: {
  flake.modules.nixos."hosts/omen" = _: {
    imports = builtins.attrValues {
      inherit
        (config.flake.modules.nixos)
        gui
        ;
    };

    networking.hostId = "56895d2b"; # FIXME:
  };
}
