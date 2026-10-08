{lib, ...}: let
  inherit (lib) concatStringsSep singleton range;

  rule = param: values:
    [param values]
    |> concatStringsSep ","
    |> singleton;
in {
  window_rule = let
    # Floating
    fa = {opt ? ""}: id: rule "is_floating:1${opt}" "app_id:${id}";
    ft = {opt ? ""}: title: rule "is_floating:1${opt}" "title:${title}";
    # Named Scratchpad
    na = {opt ? ""}: id: rule "is_named_scratchpad:1${opt}" "app_id:${id}";
    nt = {opt ? ""}: title: rule "is_named_scratchpad:1${opt}" "app_id:${title}";
    # Special worksapce
    ta = {opt ? ""}: id: rule "tags:0" "app_id:${id}";
    tt = {opt ? ""}: title: rule "tags:0" "title:${title}";
  in
    # just floating
    (map (id: fa {} id |> toString)
      <| [
        ''^blueman-manager$''
        ''^brave-.*-Default$''
        ''^valent$''
      ])
    # floating and 50% window
    ++ (map (id: fa {opt = ",width:0.50,height:0.50";} id |> toString)
      <| [
        ''^org\.gnome\.Nautilus$''
        ''^xdg-desktop-portal-gtk$''
        ''^app\.yazi$''
      ])
    # floating and fixed window
    ++ (map (id: fa {opt = ",width:1080,height:920";} id |> toString)
      <| [
        ''^dev\.noctalia\.Noctalia$''
      ])
    # floating and non-transparent
    ++ (map (id: fa {opt = ",focused_opacity:1.0";} id |> toString)
      <| [
        ''^dev\.lemmy\.swash$''
        ''^pqiv$''
      ])
    # floating, fixed window and non-transparent
    ++ (map (title: ft {opt = ",width:0.45,height:0.45,focused_opacity:1.0";} title |> toString)
      <| [
        ''^Picture-in-Picture$''
        ''^ピクチャーインピクチャー$''
        ''^ピクチャー イン ピクチャー$''
        ''^ピクチャー イン ピクチャー$''
      ])
    ++ (map (id: fa {opt = ",width:0.45,height:0.45,focused_opacity:1.0";} id |> toString)
      <| [
        ''^mpv$''
        ''^vlc$''
      ])
    # Named Scratchpad
    ++ (map (id: na {} id |> toString)
      <| [
        ''^vesktop$''
        ''^sonora$''
      ])
    # Steam game
    ++ (map (id: na {opt = ",tags:5,focused_opacity:1.0";} id |> toString)
      <| [
        ''steam_app_\d{7}$''
      ])
    # Special workspace
    ++ (map (id: ta {} id |> toString)
      <| [
        ''^footclient$''
      ]);

  tag_rule = let
    layout = num: name: rule "id:${toString num}" "layout_name:${name}";
  in
    (map (tags: layout tags "dwindle" |> toString)
      <| range 1 4)
    ++ (map (tags: layout tags "scroller" |> toString)
      <| [0] ++ range 6 9)
    ++ (map (tags: layout tags "monocle" |> toString)
      <| [5]);
}
