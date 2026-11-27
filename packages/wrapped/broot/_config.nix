{pkgs}: let
  inherit (pkgs.lib) genAttrs;
in {
  imports = [
    {
      luma = ["dark" "unknown"];
      file = "skins/catppuccin-macchiato.hjson";
    }
  ];

  default_flags = "-gs";
  icon_theme = "nerdfont";
  graphics_display = "kitty";
  kitty_graphics_transmission = "chunks";
  modal = true;
  initial_mode = "command";

  special_paths =
    genAttrs (
      [
        "/bin"
        "/boot"
        "/dev"
        "/etc"
        "/home"
        "/lib64"
        "/nix"
        "/proc"
        "/root"
        "/run"
        "/srv"
        "/sys"
        "/tmp"
        "/usr"
        "/var"
      ]
      ++ ["/backups" "/media"]
    ) (_: {
      list = "never";
      sum = "never";
    })
    // {
      "~/.config" = {
        list = "never";
        sum = "never";
        show = "always";
      };
    };
}
