{ pkgs, ...}:
{
  home.packages = [
    pkgs.custom.fuzzel-scripts
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        placeholder = "Type to search...";
        prompt = "'❯ '";
        icon-theme = "Papirus";
        match-counter = true;
        terminal = "${pkgs.kitty}/bin/kitty";
        width = 22;
        lines = 10;
        horizontal-pad = 40;
        vertical-pad = 20;
        inner-pad = 15;
      };
      border = {
        width = 2;
        radius = 8;
      };
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      vpnc = prev.vpnc.overrideAttrs (
        _oldAttrs: {
          version = "unstable-2024-12-20";

          src = final.fetchFromGitHub {
            owner = "streambinder";
            repo = "vpnc";
            rev = "d58afaaafb6a43cb21bb08282b54480d7b2cc6ab";
            hash = "sha256-79DaK1s+YmROKbcWIXte+GZh0qq9LAQlSmczooR86H8=";
          };
        }
      );
    })
  ];
}
