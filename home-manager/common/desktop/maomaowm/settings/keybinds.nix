{
  lib,
  config,
  pkgs,
  user,
  ...
}:
# == Key Bindings ==
# The mod key is not case sensitive,
# but the second key is case sensitive,
# if you use shift as one of the mod keys,
# remember to use uppercase keys
let
  actionMenu = pkgs.writers.writeFish "open_actionMenu" ''
    set choices " Lock
     Suspend
    󰿅 Exit
     Reboot
     Power Off
     Next Wallpaper"

    set choice (echo -en $choices | fuzzel --dmenu --prompt " " --placeholder "Select system actions" --lines 6)

    switch (string split -f 2 " " $choice)
        case Lock
            ${lib.getExe pkgs.hyprlock}
        case Suspend
            systemctl suspend
        case Exit
            ${lib.getExe' pkgs.procps "pkill"} -f maomao
        case Reboot
            systemctl reboot
        case Power
            systemctl poweroff
        case Next
            ${lib.getExe' config.services.wpaperd.package "wpaperctl"} next
    end
  '';

  clipboardMenu = pkgs.writers.writeFish "open_clipboardMenu" ''
    ${lib.getExe pkgs.cliphist} list \
      | fuzzel --dmenu --prompt "󰅇 " --placeholder "Search for clipboard entries..." --no-sort \
        | ${lib.getExe pkgs.cliphist} decode \
          | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}
  '';

  recordMenu = pkgs.writers.writeFish "open_recordMenu" ''
    set choices " Capture whole Screen
     Selected Area
    󰵸 Convert to GIF"

    set choice (echo -en $choices | fuzzel --dmenu --prompt " " --placeholder "Select capture actions" --lines 3)

    switch (string split -f 2 " " $choice)
        case Capture
            record_screen -s
        case Selected
            record_screen -a
        case Convert
            record_screen -g
    end
  '';

  osdCmd =
    args:
    "${lib.getExe' pkgs.swayosd "swayosd-client"} --monitor ${config.lib.monitors.mainMonitorName} ${args}";

  imeCmd = pkgs.writers.writeFish "switch_ime" ''
    fcitx5-remote -t
    ${osdCmd "--custom-message=(fcitx5-remote -n) --custom-icon=input-keyboard"}
  '';

  screenshotCmd = pkgs.writers.writeFish "take_screenshot" ''
    ${lib.getExe pkgs.grim} -g (${lib.getExe pkgs.slurp} -d) -t ppm - \
      | ${lib.getExe pkgs.satty} -f - \
        --early-exit --save-after-copy --copy-command '${lib.getExe' pkgs.wl-clipboard "wl-copy"} -t image/png' \
          -o ${config.xdg.userDirs.pictures}/Screenshots/(date +'%Y-%m-%d_%H-%M-%S.png')

  '';

  terminal = lib.getExe config.profiles.${user}.defaultTerminal.package;
  openTerminal =
    {
      app,
      app-id ? lib.getName app,
    }:
    "${terminal} -o confirm_os_window_close=0 --app-id=${app-id} ${lib.getName app}";
in
# Base binds
''
  # == Base binds ==

  # reload config
  bind=SUPER+CTRL,r,reload_config

  # close
  bind=SUPER,BackSpace,killclient

  # lock
  bind=SUPER,Escape,spawn,${lib.getExe pkgs.hyprlock}

  # quit
  bind=SUPER+SHIFT,Escape,quit

  # screenshot
  bind=SUPER,backslash,spawn,${screenshotCmd}

  # screencast-menu
  bind=SUPER+ALT,backslash,spawn,${recordMenu}
  # screencast-quit
  bind=SUPER+ALT,BackSpace,spawn,record_screen -q

  # launcher
  bind=SUPER,d,spawn,${lib.getExe pkgs.fuzzel}
  # action-menu
  bind=SUPER,q,spawn,${actionMenu}
  # clipboard-history
  bind=SUPER,v,spawn,${clipboardMenu}

  # terminal
  bind=SUPER,Return,spawn,${terminal}
''
# Programs binds

# custom app bind example
# spawn_on_empty (if tag 4 is empty , open app in this,otherwise view to tag 4)
# bind=SUPER,Return,spawn_on_empty,google-chrome,4
# spawn
# bind=CTRL+ALT,Return,spawn,st -e ~/tool/ter-multiplexer.sh

# toggle_name_scratchpad (appid,title,width,height,cmd)
# (a,none,1,1,foot)/(none,b,1,1,foot)
+ ''
  # == Programs binds==

  # file
  bind=SUPER,o,spawn,${lib.getExe pkgs.nemo}

  # browser
  bind=SUPER,b,spawn,librewolf

  # discord
  bind=SUPER,w,spawn,${lib.getExe pkgs.vesktop}

  # spotify
  bind=SUPER,s,spawn,spotify

  # yazi
  bind=SUPER+SHIFT,o,spawn,${openTerminal { app = pkgs.yazi; }}

  # nix-search-tv
  bind=SUPER,p,spawn,${
    openTerminal {
      app = "ns";
      app-id = lib.getName pkgs.nix-search-tv;
    }
  }

  # dunst
  bind=SUPER+SHIFT,n,spawn,${lib.getExe' pkgs.dunst "dunstctl"} history-pop
  bind=SUPER+ALT,n,spawn,${lib.getExe' pkgs.dunst "dunstctl"} close-all

  # media-key
  bind=none,XF86AudioRaiseVolume,spawn,${osdCmd "--output-volume raise"}
  bind=none,XF86AudioLowerVolume,spawn,${osdCmd "--output-volume lower"}
  bind=none,XF86AudioMute,spawn,${osdCmd "--output-volume mute-toggle"}
  bind=none,XF86AudioMicMute,spawn,${osdCmd "--output-volume mute-toggle"}
  bind=none,XF86AudioPlay,spawn,${osdCmd "--playerctl=play-pause"}
  bind=none,XF86AudioPause,spawn,${osdCmd "--playerctl=play-pause"}
  bind=none,XF86AudioNext,spawn,${osdCmd "--playerctl=next"}
  bind=none,XF86AudioPrev,spawn,${osdCmd "--playerctl=previous"}
  bind=none,XF86MonBrightnessUp,spawn,${osdCmd "--brightness raise"}
  bind=none,XF86MonBrightnessDown,spawn,${osdCmd "--brightness lower"}

  # ime
  bind=CTRL,space,spawn,${imeCmd}
''
# Windows binds
+ ''
  # == Windows binds ==

  # switch window focus
  bind=SUPER,h,focusdir,left
  bind=SUPER,l,focusdir,right
  bind=SUPER,k,focusdir,up
  bind=SUPER,j,focusdir,down

  # swap window
  bind=SUPER+SHIFT,K,exchange_client,up
  bind=SUPER+SHIFT,J,exchange_client,down
  bind=SUPER+SHIFT,H,exchange_client,left
  bind=SUPER+SHIFT,L,exchange_client,right

  # switch window status
  bind=SUPER,g,toggleglobal,
  bind=SUPER,Tab,toggleoverview,
  bind=SUPER+SHIFT,space,togglefloating,
  bind=SUPER,m,togglemaxmizescreen,
  bind=SUPER+SHIFT,F,togglefullscreen,
  bind=SUPER,i,minized,
  bind=SUPER+SHIFT,I,restore_minized
  bind=ALT,z,toggle_scratchpad
''
# Layout binds
+ ''
  # == Layout binds ==

  # scroller layout
  bind=SUPER,f,set_proportion,1.0
  bind=SUPER,r,switch_proportion_preset,

  # tile layout
  bind=SUPER,e,incnmaster,1
  bind=SUPER,t,incnmaster,-1
  bind=ALT+CTRL,Left,setmfact,-0.01
  bind=ALT+CTRL,Right,setmfact,+0.01
  bind=ALT+CTRL,Up,setsmfact,-0.01
  bind=ALT+CTRL,Down,setsmfact,+0.01
  bind=ALT,s,zoom,

  # switch layout
  bind=CTRL+SUPER,t,setlayout,tile
  bind=CTRL+SUPER,s,setlayout,scroller
  bind=SUPER,n,switch_layout

  # tag switch
  bind=SUPER,Left,viewtoleft,
  bind=CTRL,Left,viewtoleft_have_client,
  bind=SUPER,Right,viewtoright,
  bind=CTRL,Right,viewtoright_have_client,
  bind=CTRL+SUPER,Left,tagtoleft,
  bind=CTRL+SUPER,Right,tagtoright,
''
# normal num key  is (1-9)
# right-side keyboard num keys is (KP_1-KP_9)
+ ''
  # == Num-key binds ==

  bind=SUPER,1,view,1
  bind=SUPER,2,view,2
  bind=SUPER,3,view,3
  bind=SUPER,4,view,4
  bind=SUPER,5,view,5
  bind=SUPER,6,view,6
  bind=SUPER,7,view,7
  bind=SUPER,8,view,8
  bind=SUPER,9,view,9

  bind=SUPER+SHIFT,exclam,tag,1
  bind=SUPER+SHIFT,at,tag,2
  bind=SUPER+SHIFT,numbersign,tag,3
  bind=SUPER+SHIFT,dollar,tag,4
  bind=SUPER+SHIFT,percent,tag,5
  bind=SUPER+SHIFT,asciicircum,tag,6
  bind=SUPER+SHIFT,ampersand,tag,7
  bind=SUPER+SHIFT,asterisk,tag,8
  bind=SUPER+SHIFT,parenleft,tag,9

  bind=SUPER+CTRL+SHIFT,exclam,toggletag,1
  bind=SUPER+CTRL+SHIFT,at,toggletag,2
  bind=SUPER+CTRL+SHIFT,numbersign,toggletag,3
  bind=SUPER+CTRL+SHIFT,dollar,toggletag,4
  bind=SUPER+CTRL+SHIFT,percent,toggletag,5
  bind=SUPER+CTRL+SHIFT,asciicircum,toggletag,6
  bind=SUPER+CTRL+SHIFT,ampersand,toggletag,7
  bind=SUPER+CTRL+SHIFT,asterisk,toggletag,8
  bind=SUPER+CTRL+SHIFT,parenleft,toggletag,9

  bind=SUPER+CTRL,1,toggleview,1
  bind=SUPER+CTRL,2,toggleview,2
  bind=SUPER+CTRL,3,toggleview,3
  bind=SUPER+CTRL,4,toggleview,4
  bind=SUPER+CTRL,5,toggleview,5
  bind=SUPER+CTRL,6,toggleview,6
  bind=SUPER+CTRL,7,toggleview,7
  bind=SUPER+CTRL,8,toggleview,8
  bind=SUPER+CTRL,9,toggleview,9
''
# monitor switch
+ ''
  # == Monitor switch ==

  bind=SUPER+CTRL,h,focusmon,left
  bind=SUPER+CTRL,l,focusmon,right
  bind=SUPER+CTRL+SHIFT,H,tagmon,left
  bind=SUPER+CTRL+SHIFT,L,tagmon,right
''
# gaps
+ ''
  # == Gaps ==
  bind=ALT+SHIFT,X,incgaps,1
  bind=ALT+SHIFT,Z,incgaps,-1
  bind=ALT+SHIFT,R,togglegaps
''
# Mouse Button Bindings
# NONE: mode key only work in ov mode
+ ''
  # == Mouse Button ==

  mousebind=SUPER,btn_left,moveresize,curmove
  mousebind=NONE,btn_middle,togglemaxmizescreen,0
  mousebind=ALT,btn_left,moveresize,curresize
  mousebind=NONE,btn_left,toggleoverview,-1
  mousebind=NONE,btn_right,killclient,0
''
# gesture
+ ''
  # == Gesture ==

  gesturebind=NONE,left,3,focusdir,right
  gesturebind=NONE,right,3,focusdir,left
  gesturebind=NONE,up,3,focusdir,down
  gesturebind=NONE,down,3,focusdir,up
  gesturebind=NONE,left,4,viewtoleft_have_client
  gesturebind=NONE,right,4,viewtoright_have_client
  gesturebind=NONE,up,4,toggleoverview
  gesturebind=NONE,down,4,toggleoverview
''
# Axis Bindings
+ ''
  # == Axis Bindings ==

  axisbind=SUPER,UP,viewtoleft_have_client
  axisbind=SUPER,DOWN,viewtoright_have_client
''
