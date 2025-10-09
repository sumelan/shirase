{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.webcord-vencord];

  programs.niri.settings = {
    binds = {
      "Mod+W" = {
        action.spawn = ["webcord"];
        hotkey-overlay.title = ''<span foreground="${config.lib.stylix.colors.withHashtag.base0B}">[Application]</span> Webcord'';
      };
    };
  };

  stylix.targets.vencord.enable = false;

  custom.persist = {
    home.directories = [
      ".config/WebCord"
    ];
  };
}
