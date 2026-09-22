{lib, ...}: let
  inherit (lib) concatStringsSep singleton range;

  rule = param: values:
    [param values]
    |> concatStringsSep ","
    |> singleton;
in {
  windowrule = let
    # Floating
    fa = {opt ? ""}: id: rule "isfloating:1${opt}" "appid:${id}";
    ft = {opt ? ""}: title: rule "isfloating:1${opt}" "title:${title}";
    # Named Scratchpad
    na = {opt ? ""}: id: rule "isnamedscratchpad:1${opt}" "appid:${id}";
    nt = {opt ? ""}: title: rule "isnamedscratchpad:1${opt}" "appid:${title}";
    # Special worksapce
    ta = {opt ? ""}: id: rule "tags:0" "appid:${id}";
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
        ''^dev.geopjr.Tuba$''
        ''^readest$''
      ])
    # Special workspace
    ++ (map (id: ta {} id |> toString)
      <| [
        ''^footclient$''
      ]);

  tagrule = let
    layout = num: name: rule "id:${toString num}" "layout_name:${name}";
  in
    (map (tags: layout tags "dwindle" |> toString)
      <| range 1 4)
    ++ (map (tags: layout tags "scroller" |> toString)
      <| [0] ++ range 6 9)
    ++ (map (tags: layout tags "vertical_scroller" |> toString)
      <| [5]);
}
