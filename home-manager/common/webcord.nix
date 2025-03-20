{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    webcord
  ];

  programs.niri.settings.window-rules = [
    {
      matches = [ { app-id = "^(WebCord)$"; } ];
      default-column-width = {
        proportion = 0.6;
      };
    }
  ];

  custom.persist = {
    home.directories = [
      ".config/WebCord"
    ];
  };
}
