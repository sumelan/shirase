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
        proportion = 0.8;
      };
    }
  ];

  custom.persist = {
    home.directories = [
      ".config/WebCord"
    ];
  };
}
