{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pwvucontrol
  ];

  programs.niri.settings.window-rules = [
    {
      matches = [ { app-id = "^(pwvucontrol)$"; } ];
      open-floating = true;
    }
  ];
}
