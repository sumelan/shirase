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
      matches = [{ app-id = "^(webcord)$"; }];
      default-column-width = {
        proportion = 1.0;
      };
    }
  ];

  custom.persist = {
    home.directories = [
      ".config/WebCord"
    ];
  };
}
