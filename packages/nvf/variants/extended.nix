# Additional language server for development machines
{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nvf.full = _: {
    imports = with flake.modules.nvf; [
      default
      blink
      themes
      transparent
      neotree
      languages
      go
      python
      nix
      telescope
    ];
  };
}
