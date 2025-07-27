{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = {
    protonapp.enable = lib.mkEnableOption "Enable Proton apps";
  };

  config = lib.mkIf config.custom.protonapp.enable {
    # NOTE: protonmail-desktop need to be started onece through xwayland with
    # 'XDG_SESSION_TYPE=x11 DISPLAY=:0 proton-mail'
    # but after that it worked without them
    # https://github.com/NixOS/nixpkgs/issues/365156#issuecomment-2585203352
    home.packages = with pkgs; [
      protonmail-desktop
      proton-pass
      protonvpn-gui
    ];

    custom.persist = {
      home = {
        directories = [
          ".config/Proton"
          ".config/Proton Mail"
          ".config/Proton Pass"
        ];
        cache.directories = [
          ".cache/Proton"
        ];
      };
    };
  };
}
