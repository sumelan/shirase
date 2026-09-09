{lib, ...}: {
  windowrule = let
    rule = param: values:
      [param values]
      |> lib.concatStringsSep ","
      |> lib.singleton;
    fa = {opt ? ""}: id: rule "isfloating:1${opt}" "appid:${id}";
    ft = {opt ? ""}: title: rule "isfloating:1${opt}" "title:${title}";
  in
    # floating
    fa {} ''^\.blueman-manager-wrapped$''
    ++ fa {} ''^brave-.*-Default$''
    ++ fa {} ''^valent$''
    ++ fa {} ''^org\.gnome\.Nautilus$''
    ++ fa {} ''^org\.gnome\.Nautilus$''
    ++ fa {} ''^xdg-desktop-portal-gtk$''
    ++ fa {} ''^app\.yazi$''
    ++ fa {} ''^dev\.noctalia\.Noctalia$''
    # floating and non-transparent
    ++ ft {opt = ",focused_opacity:1.0";} ''^Picture-in-Picture$''
    ++ ft {opt = ",focused_opacity:1.0";} ''^ピクチャーインピクチャー$''
    ++ ft {opt = ",focused_opacity:1.0";} ''^ピクチャー イン ピクチャー$''
    ++ ft {opt = ",focused_opacity:1.0";} ''^ピクチャー イン ピクチャー$''
    ++ fa {opt = ",focused_opacity:1.0";} ''^mpv$''
    ++ fa {opt = ",focused_opacity:1.0";} ''^dev\.lemmy\.swash$''
    ++ fa {opt = ",focused_opacity:1.0";} ''^pqiv$''
    ++ fa {opt = ",focused_opacity:1.0";} ''^vlc$''
    ++ [
      # Terminal swallowdby setup
      "isterm:1,appid:foot"
      "noswallow:1,appid:kitty"
    ];
}
