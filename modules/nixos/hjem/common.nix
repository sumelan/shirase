{config, ...}: {
  flake.modules.nixos.hjemCommon = _: {
    imports = let
      extendedConfigs = [
        "audio-disc"
        "blu-ray"
      ];
    in
      builtins.attrValues (
        removeAttrs
        config.flake.custom.hjemConfigs
        extendedConfigs
      );
  };
}
