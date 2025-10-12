{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.vesktop];

  programs.niri.settings = {
    binds = {
      "Mod+W" = {
        action.spawn = ["vesktop"];
        hotkey-overlay.title = ''<span foreground="${config.lib.stylix.colors.withHashtag.base0B}">[Application]</span> Vesktop'';
      };
    };
  };

  custom.persist = {
    home.directories = [
      ".config/vesktop"
    ];
  };
}
