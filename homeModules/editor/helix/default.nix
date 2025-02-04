{ config, lib, ... }:
{
  imports = [
    ./languages.nix
  ];

  options.custom = with lib; {
    helix.enable = mkEnableOption "helix";
  };

  config = lib.mkIf config.custom.helix.enable {
    programs.helix = {
      enable = true;
      settings = {
        editor = {
          line-number = "relative";
          cursorline = true;
          auto-format = true;
          completion-replace = true;
          rulers = [ 80 ];
          bufferline = "multiple";
          color-modes = true;
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          indent-guides.render = true;
        };
      };
    };
  };
}
