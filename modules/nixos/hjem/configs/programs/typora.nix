{lib, ...}: {
  flake.custom.hjemConfigs.typora = {
    pkgs,
    user,
    ...
  }: let
    waylandTypora = pkgs.symlinkJoin {
      name = "typora";
      paths = [pkgs.typora];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/typora \
          --add-flags "--enable-features=UseOzonePlatform" \
          --add-flags "--ozone-platform=wayland" \
          --add-flags "--enable-wayland-ime" \
          --add-flags "--wayland-text-input-version=3"
      '';
    };
  in {
    hjem.users.${user}.rum = {
      programs.typora = {
        enable = lib.mkDefault true;
        package = waylandTypora;
        advancedSettings = {
          defaultFontFamily = {
            standard = "Montserrat";
            serif = "Montserrat";
            sansSerif = "Montserrat";
            monospace = "Maple Mono NF";
          };
          autoHideMenuBar = true; # Boolean - Auto hide the menu bar unless the `Alt` key is pressed. Default is false.

          # Array - Search Service user can access from context menu after a range of text is selected. Each item is formatted as [caption, url]
          searchService = [
            ["Search with Kagi" "https://kagi.com/search?q=%s"]
          ];

          # Custom key binding, which will override the default ones.
          # See <https://support.typora.io/Shortcut-Keys/#windows--linux> for detail
          keyBinding = {
            # for example:
            # "Always on Top" =  "Ctrl+Shift+P";
            # All other options are the menu items 'text label' displayed from each typora menu
          };

          monocolorEmoji = false; # default false. Only work for Windows
          maxFetchCountOnFileList = 500;
          flags = []; # default [], append Chrome launch flags, e.g: [["disable-gpu"], ["host-rules", "MAP * 127.0.0.1"]]
        };
      };
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/Typora"
      ];
    };
  };
}
