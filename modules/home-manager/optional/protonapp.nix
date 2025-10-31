{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    protonapp.enable = mkEnableOption "Enable Proton apps";
  };

  config = mkIf config.custom.protonapp.enable {
    # NOTE: protonmail-desktop need to be started onece through xwayland with
    # 'XDG_SESSION_TYPE=x11 DISPLAY=:0 proton-mail'
    # but after that it worked without them
    # https://github.com/NixOS/nixpkgs/issues/365156#issuecomment-2585203352
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        protonmail-desktop
        proton-pass
        protonvpn-gui
        ;
    };

    programs.niri.settings = {
      window-rules = [
        {
          matches = [
            {app-id = "^(Proton Mail)$";}
            {app-id = "^(Proton Pass)$";}
            {app-id = "^(.protonvpn-app-wrapped)$";}
          ];
          block-out-from = "screen-capture";
        }
      ];
    };
  };
}
