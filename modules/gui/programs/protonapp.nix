# NOTE: `protonmail-desktop` need to be started once through xwayland with
# `XDG_SESSION_TYPE=x11 DISPLAY=:0 proton-mail`
# but after that it worked without them
# https://github.com/NixOS/nixpkgs/issues/365156#issuecomment-2585203352
_: let
  inherit (builtins) attrValues;
in {
  flake.modules.homeManager.protonapp = {pkgs, ...}: {
    home.packages = attrValues {
      inherit
        (pkgs)
        protonmail-desktop
        proton-pass
        protonvpn-gui
        ;
    };

    custom = {
      persist.home.directories = [
        ".config/Proton"
        ".config/Proton Mail"
        ".config/Proton Pass"
      ];
      cache.home.directories = [
        ".cache/Proton"
      ];
    };
  };
}
