{config, ...}: {
  flake.modules.nixos.hjem-extended = _: {
    imports = builtins.attrValues {
      inherit
        (config.flake.custom.hjemConfigs)
        audio-disc
        blu-ray
        zed-editor
        ;
    };
  };
}
