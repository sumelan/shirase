{
  config,
  isLaptop,
  ...
}:
let
  inherit (config.lib.monitors) mainMonitor;
  mainScale = mainMonitor.scale |> builtins.toString;
  monitorMode =
    layout: "monitorrule=${config.lib.monitors.mainMonitorName},0,1,${layout},0,${mainScale},0,0";
  monitorRules = if isLaptop then monitorMode "scroller" else monitorMode "tile";
in
# == tags rule ==
# layout support: tile,scroller,grid,monocle,spiral,dwindle
''
  tags=id:1,layout_name:scroller
  tags=id:2,layout_name:scroller
  tags=id:3,layout_name:scroller
  tags=id:4,layout_name:scroller
  tags=id:5,layout_name:scroller
  tags=id:6,layout_name:scroller
  tags=id:7,layout_name:scroller
  tags=id:8,layout_name:scroller
  tags=id:9,layout_name:scroller
''
# == Window Rules ==
+ ''
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
''
# Monitor Rules
+ ''
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

  ${monitorRules}
''
