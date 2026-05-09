{
  inputs,
  lib,
  ...
}: let
  inherit (inputs.niri-nix.lib) validatedConfigFor mkNiriKDL;
in {
  flake.modules.nixos.niri = {
    config,
    pkgs,
    dotfile,
    ...
  }: let
    niriCfg = import ./_config.nix {inherit config lib pkgs dotfile;};
  in {
    programs.niri = {
      enable = true;
      package = pkgs.niri;
      useNautilus = true;
      withUWSM = false;
      withXDG = true;
    };

    xdg.portal = {
      config = {
        common.default = ["gtk"];
        niri = {
          default = ["gnome" "gtk"];
          "org.freedesktop.impl.portal.Access" = ["gtk"];
          # i use nautilus
          "org.freedesktop.impl.portal.FileChooser" = ["gnome"];
          "org.freedesktop.impl.portal.Notification" = ["gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        };
      };
    };

    hj.xdg.config.files = let
      inherit (config.programs.niri) package;
    in {
      "niri/config.kdl".source = validatedConfigFor package (mkNiriKDL niriCfg);
    };
  };
}
