{
  lib,
  config,
  pkgs,
  user,
  isLaptop,
  ...
}:
let
  appearance = import ./appearance.nix { inherit config; };
  keybinds = import ./keybinds.nix {
    inherit
      lib
      config
      pkgs
      user
      ;
  };
  rules = import ./rules.nix { inherit config isLaptop; };
in
{
  wayland.windowManager.maomaowm.settings = ''
    # == Master-Stack Layout Setting (tile,spiral,dwindle) ==
    new_is_master=0
    default_mfact=0.55
    default_nmaster=1
    smartgaps=1
    # only work in spiral and dwindlw
    default_smfact=0.5 

    # == Scroller Layout Setting ==
    scroller_structs=20
    scroller_default_proportion=0.8
    scoller_focus_center=0
    scroller_proportion_preset=0.5,0.8,1.0

    # == Overview Setting ==
    hotarea_size=10
    enable_hotarea=1
    ov_tab_mode=0
    overviewgappi=5
    overviewgappo=30

    # == Misc ==
    xwayland_persistenc=0
    focus_cross_tag=0
    focus_cross_monitor=0
    axis_bind_apply_timeout=100
    focus_on_activate=1
    bypass_surface_visibility=0
    sloppyfocus=1
    warpcursor=1

    # == keyboard ==
    repeat_rate=25
    repeat_delay=600
    numlockon=1
      
    # == Trackpad ==
    tap_to_click=1
    tap_and_drag=1
    drag_lock=1
    trackpad_natural_scrolling=1
    disable_while_typing=1
    left_handed=0
    middle_button_emulation=0

    ${appearance}
    ${rules}
    ${keybinds}

    # == scale factor about qt (herr is 1.4) ==
    env=QT_QPA_PLATFORMTHEME,qt5ct
    env=QT_AUTO_SCREEN_SCALE_FACTOR,1
    env=QT_QPA_PLATFORM,Wayland;xcb
    env=QT_WAYLAND_FORCE_DPI,140
  '';
}
