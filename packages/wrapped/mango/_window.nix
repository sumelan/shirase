{lib, ...}: let
  inherit (lib) concatStringsSep singleton;
in {
  windowrule = let
    rule = param: values:
      [param values]
      |> concatStringsSep ","
      |> singleton;
    fa = {opt ? ""}: id: rule "isfloating:1${opt}" "appid:${id}";
    ft = {opt ? ""}: title: rule "isfloating:1${opt}" "title:${title}";
  in
    # floating
    fa {} ''^blueman-manager$''
    ++ fa {} ''^brave-.*-Default$''
    ++ fa {} ''^valent$''
    ++ fa {opt = ",width:0.50,height:0.50";} ''^org\.gnome\.Nautilus$''
    ++ fa {opt = ",width:0.50,height:0.50";} ''^xdg-desktop-portal-gtk$''
    ++ fa {opt = ",width:0.50,height:0.50";} ''^app\.yazi$''
    ++ fa {opt = ",width:1080,height:920";} ''^dev\.noctalia\.Noctalia$''
    # floating and non-transparent
    ++ fa {opt = ",focused_opacity:1.0";} ''^dev\.lemmy\.swash$''
    ++ fa {opt = ",focused_opacity:1.0";} ''^pqiv$''
    ++ ft {opt = ",width:0.45,height:0.45,focused_opacity:1.0";} ''^Picture-in-Picture$''
    ++ ft {opt = ",width:0.45,height:0.45,focused_opacity:1.0";} ''^ピクチャーインピクチャー$''
    ++ ft {opt = ",width:0.45,height:0.45,focused_opacity:1.0";} ''^ピクチャー イン ピクチャー$''
    ++ ft {opt = ",width:0.45,height:0.45,focused_opacity:1.0";} ''^ピクチャー イン ピクチャー$''
    ++ fa {opt = ",width:0.45,height:0.45,focused_opacity:1.0";} ''^mpv$''
    ++ fa {opt = ",width:0.45,height:0.45,focused_opacity:1.0";} ''^vlc$''
    # Special workspace
    ++ [
      "tags:0,appid:com.blitzfc.qbz"
    ];
}
