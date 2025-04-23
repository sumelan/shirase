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
        proportion = 0.5;
      };
    }
  ];

  custom.persist = {
    home.directories = [
      ".config/WebCord"
    ];
  };
}
