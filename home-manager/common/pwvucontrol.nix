{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pwvucontrol
  ];

  programs.niri.settings.window-rules = [
    {
      matches = [{ app-id = "^(com.saivert.pwvucontrol)$"; }];
      open-floating = true;
    }
  ];
}
