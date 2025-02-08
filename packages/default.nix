{ pkgs, ... }:
let
  inherit (pkgs) lib callPackage;
  # injects a source parameter from nvfetcher
  # adapted from viperML's config
  # https://github.com/viperML/dotfiles/blob/master/packages/default.nix
  w =
    _callPackage: path: extraOverrides:
    let
      sources = pkgs.callPackages (path + "/generated.nix") { };
      firstSource = lib.head (lib.attrValues sources);
    in
    _callPackage (path + "/default.nix") (
      extraOverrides // { source = lib.filterAttrs (k: _: !(lib.hasPrefix "override" k)) firstSource; }
    );
  repo_url = "https://raw.githubusercontent.com/Sumelan/wolborg";
in
rec {
  default = install;

  install = pkgs.writeShellApplication {
    name = "sumelan-install";
    runtimeInputs = [ pkgs.curl ];
    text = "sh <(curl -L ${repo_url}/main/install.sh)";
  };

  # custom tela built with catppucin variant colors
  tela-dynamic-icon-theme = callPackage ./tela-dynamic-icon-theme { };

  distro-grub-themes-nixos = callPackage ./distro-grub-themes-nixos { };

  # for nixos-rebuild
  hsw = callPackage ./hsw { };
  nsw = callPackage ./nsw { };

  rofi-themes = w callPackage ./rofi-themes { };
  rofi-power-menu = callPackage ./rofi-power-menu { };
  rofi-wifi-menu = callPackage ./rofi-wifi-menu { };

  vv =
    assert (lib.assertMsg (!(pkgs ? "vv")) "vv: vv is in nixpkgs");
    (w callPackage ./vv { });
}
