{
  config,
  isLaptop,
  ...
}:
let
  inherit (config.lib.monitors) mainMonitor;
  mainScale = mainMonitor.scale |> builtins.toString;
  monitorMode =
    layout: "monitorrule=${config.lib.monitors.mainMonitorName},0.55,1,${layout},0,${mainScale},0,0";
  monitorRules = if isLaptop then monitorMode "scroller" else monitorMode "tile";
in
# Tags Rules

# layout support: tile,scroller,monocle,grid,dwindle,spiral,deck
# Format:
# tagrule=id:Values,Parameter:Values,Parameter:Values
# tagrule=id:Values,monitor_name:eDP-1,Parameter:Values,Parameter:Values

''
  # == Tags Rules ==

''
# Layer Rules

# Format:
# layerrule=layer_name:Values,Parameter:Values,Parameter:Values

+ ''
  # == Layer Rules ==

  # slurp select layer
  layerrule=noblur:1,noanim:1,layer_name:selection

  # dimland
  layerrule=noblur:1,noanim:1,layer_name:dimland_layer
''
# Window Rules

# appid: type-string if match it or title, the rule match
# title: type-string if match it or appid, the rule match
# tags: type-num(1-9)
# isfloating: type-num(0 or 1)
# isfullscreen: type-num(0 or 1)
# scroller_proportion: type-float(0.1-1.0)
# animation_type_open : type-string(zoom,slide,none)
# animation_type_close : type-string(zoom,slide)
# isnoborder : type-num(0 or 1)
# monitor  : type-int(0-99999)
# width : type-num(0-9999)
# height : type-num(0-9999)
# isterm : type-num (0 or 1) -- when new window open, will replace it, and will restore after the sub window exit
# nnoswallow : type-num(0 or 1) -- if enable, this window wll not replace isterm window when it was open by isterm window
# globalkeybinding: type-string(for example-- alt-l or alt+super-l)

# example
# windowrule=isfloating:1,appid:yesplaymusic
# windowrule=width:1500,appid:yesplaymusic
# windowrule=height:900,appid:yesplaymusic
# windowrule=isfloating:1,title:qxdrag
# windowrule=isfloating:1,appid:Rofi
# windowrule=isfloating:1,appid:wofi
# windowrule=isnoborder:1,appid:wofi
# windowrule=animation_type_open:zoom,appid:wofi
# windowrule=globalkeybinding:ctrl+alt-o,appid:com.obsproject.Studio
# windowrule=globalkeybinding:ctrl+alt-n,appid:com.obsproject.Studio

# open in specific tag
# windowrule=tags:4,appid:Google-chrome
# windowrule=tags:3,appid:QQ
# windowrule=tags:5,appid:yesplaymusic
# windowrule=tags:2,appid:mpv
# windowrule=tags:6,appid:obs

+ ''
  # == Window Rules ==

  # nemo
  windowrule=isfloating:1,appid:nemo
  windowrule=isfloating:1,appid:xdg-desktop-portal-gtk

  # spotify mini player
  windowrule=isfloating:1,appid:chromium-browser

  # swayimg
  windowrule=isfloating:1,appid:swayimg

  # pwvucontrol
  windowrule=isfloating:1,appid:com.saivert.pwvucontrol

  # easyeffects
  windowrule=isfloating:1,appid:com.github.wwmm.easyeffects

  # bluetooth
  windowrule=isfloating:1,appid:.blueman-manager-wrapped

  # librewolf
  windowrule=isfloating:1,appid:librewolf,title:ピクチャーインピクチャー
  windowrule=isfloating:1,appid:librewolf,title:Save File
  windowrule=isfloating:1,appid:librewolf,title:(.*)wants to save
''
# Monitor Rules

# name|mfact|nmaster|scale|layout|(rotate or reflect)|x|y
# rotate or reflect:
# 0:no transform
# 1:90 degrees counter-clockwise
# 2:180 degrees counter-clockwise
# 3:270 degrees counter-clockwise
# 4:180 degree flip around a vertical axis
# 5:flip and rotate 90 degrees counter-clockwise
# 6:flip and rotate 180 degrees counter-clockwise
# 7:flip and rotate 270 degrees counter-clockwise

+ ''
  # == Monitor Rules ==

  ${monitorRules}
''
