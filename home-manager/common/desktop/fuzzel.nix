{
  lib,
  config,
  pkgs,
  user,
  isLaptop,
  ...
}:
let
  opacity = config.stylix.opacity.popups * 255 |> builtins.ceil |> lib.toHexString;

  actionCmd = pkgs.writers.writeFish "fuzzel-actions" ''
    set choices " Lock
     Suspend
    󰿅 Exit
     Reboot
     Poweroff
    󰸉 Change-Wallpaper"

    set choice (echo -en $choices | fuzzel --dmenu --prompt " " --placeholder "Search for System actions..." --lines 6)

    switch (string split -f 2 " " $choice)
        case Lock
            ${lib.getExe pkgs.hyprlock}
        case Suspend
            systemctl suspend
        case Exit
            niri msg action quit
        case Reboot
            systemctl reboot
        case Poweroff
            systemctl poweroff
        case Change-Wallpaper
            ${lib.getExe' pkgs.wpaperd "wpaperctl"} next
    end
  '';

  recordCmd = pkgs.writers.writeFish "fuzzel-recorder" ''
    set choices " Record-Screen
     Record-Area
    󰵸 Record-toGif
     Quit-Recording"

    set choice (echo -en $choices | fuzzel --dmenu --prompt " " --placeholder "Search for Recorder actions..." --lines 4)

    switch (string split -f 2 " " $choice)
        case Record-Screen
            record_screen -s
        case Record-Area
            record_screen -a
        case Record-toGif
            record_screen -g
        case Quit-Recording
            record_screen -q
    end
  '';

  clipCmd = pkgs.writers.writeFish "fuzzel-clipboard" ''
    ${lib.getExe pkgs.cliphist} list | fuzzel --dmenu --prompt "󰅇 " --placeholder "Search for clipboard entries..." --no-sort | ${lib.getExe pkgs.cliphist} decode | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}
  '';

  windowCmd = pkgs.writers.writeFish "fuzzel-windows" ''
    set windows (niri msg -j windows)
    set ids (echo $windows | jq -r '.[] | .id')
    set app_ids (echo $windows | jq -r '.[] | .app_id' )
    set titles (echo $windows | jq -r '.[] | .title' )
    set choices ""

    for i in (seq (count $ids))
      set choices "$choices$titles[$i]\t$app_ids[$i]\0icon\x1f$app_ids[$i]\n"
    end

    set choices (string trim -c "\n" $choices)

    set choice (echo -e $choices | fuzzel --counter --dmenu --prompt " " --placeholder "Search for windows..." --index --tabs 200 || exit)
    if [ "x$choice" != "x" ] && [ $choice != -1 ]
      niri msg action focus-window --id $ids[(math $choice + 1)]
    end
  '';
in
{
  programs = {
    fuzzel = {
      enable = true;
      settings = {
        main = {
          layer = "overlay";
          placeholder = "Type to search...";
          prompt = "'❯ '";
          font =
            with config.stylix.fonts;
            let
              sizeParamater = if isLaptop then 2 else (-2);
            in
            "${sansSerif.name}:size=${sizes.popups - sizeParamater |> builtins.toString}";
          icon-theme = config.stylix.iconTheme.dark;
          match-counter = true;
          terminal = "${lib.getExe config.profiles.${user}.defaultTerminal.package}";
          width = 24;
          lines = 12;
          horizontal-pad = 25;
          vertical-pad = 8;
          inner-pad = 5;
        };
        border = {
          width = 2;
          radius = 10;
        };
        colors = with config.lib.stylix.colors; {
          background = "${base00-hex}${opacity}";
          border = "${base0B-hex}ff";
          counter = "${base06-hex}ff";
          input = "${base05-hex}ff";
          match = "${base0A-hex}ff";
          placeholder = "${base03-hex}ff";
          prompt = "${base05-hex}ff";
          selection = "${base03-hex}ff";
          selection-match = "${base0A-hex}ff";
          selection-text = "${base05-hex}ff";
          text = "${base05-hex}ff";
        };
      };
    };
    niri.settings.binds =
      with config.lib.niri.actions;
      let
        ush = program: spawn "sh" "-c" "uwsm app -- ${program}";
      in
      {
        "Mod+D" = {
          action = ush "fuzzel";
          hotkey-overlay.title = "Fuzzel";
        };
        "Alt+Escape" = {
          action = ush windowCmd;
          hotkey-overlay.title = "Windows Search";
        };
        "Mod+R" = {
          action = ush recordCmd;
          hotkey-overlay.title = "Recorder";
        };
        "Mod+Q" = {
          action = ush actionCmd;
          hotkey-overlay.title = "System Actions";
        };
        "Mod+V" = {
          action = ush clipCmd;
          hotkey-overlay.title = "Show Clipboard History";
        };
      };
  };
  stylix.targets.fuzzel.enable = false;
}
