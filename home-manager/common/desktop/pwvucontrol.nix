{ pkgs, ... }:
{
  home.packages = with pkgs; [ pwvucontrol ];

  programs.niri.settings.window-rules = [
    {
      matches = [ { app-id = "^(com.saivert.pwvucontrol)$"; } ];
      open-floating = true;
      default-column-width.proportion = 0.4;
      default-window-height.proportion = 0.4;
    }
  ];

  custom.persist = {
    home.directories = [
      ".local/state/wireplumber"
    ];
  };
}
