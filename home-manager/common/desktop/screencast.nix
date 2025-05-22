{
  config,
  pkgs,
  self,
  ...
}:
{
  home.packages = with pkgs; [ wl-screenrec ] ++ [ self.packages.${pkgs.system}.screencast ];

  programs.niri.settings.binds = with config.lib.niri.actions; {
    "Mod+Shift+R" = {
      action = spawn "screencast";
      hotkey-overlay.title = "Record Screen";
    };
  };
}
