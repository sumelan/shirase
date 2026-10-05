{config, ...}: {
  flake.modules.nixos."hosts/omen" = _: {
    imports = builtins.attrValues {
      inherit
        (config.flake.custom.hjemConfigs)
        audio-disc
        blu-ray
        ;
    };
  };
}
