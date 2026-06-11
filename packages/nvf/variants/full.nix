# Additional language server for development machines
{config, ...}: {
  flake.modules.nvf.full = _: {
    imports = builtins.attrValues {
      inherit
        (config.flake.modules.nvf)
        default
        blink
        themes
        transparent
        neotree
        languages
        go
        python
        nix
        rust
        telescope
        ;
    };
  };
}
