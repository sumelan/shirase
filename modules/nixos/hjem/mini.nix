{config, ...}: {
  flake.modules.nixos.hjemMini = _: {
    imports = builtins.attrValues {
      inherit
        (config.flake.custom.hjemConfigs)
        btop
        yt-dlp
        nushell
        ;
    };
  };
}
