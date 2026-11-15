_: {
  imports = [
    {
      luma = ["dark" "unknown"];
      file = "skins/catppuccin-macchiato.hjson";
    }
  ];

  default_flags = "-gs";
  icon_theme = "nerdfont";

  modal = true;
  initial_mode = "command";

  special_paths = let
    noListSumAttrs = list:
      builtins.listToAttrs (map (name: {
          inherit name;
          value = {
            list = "never";
            sum = "never";
          };
        })
        list);
  in
    noListSumAttrs
    ([
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
      ++ ["/backups" "/media"])
    // {
      "~/.config" = {
        list = "never";
        sum = "never";
        show = "always";
      };
    };
}
