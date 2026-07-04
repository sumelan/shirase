{
  pkgs,
  extraOptions,
  extraActions,
  extraKeybindings,
  extraConfig,
  ...
}:
pkgs.writeTextFile {
  name = "pqivrc";
  destination = "/pqivrc"; # pqiv expects a directory
  text = ''
    [options]
    box-colors = #ECEFF4:#5E81AC
    disable-backends = archive,archive_cbx,libav,poppler,spectre,wand
    hide-info-box = 1
    max-depth = 1
    window-position = off
    ${extraOptions}

    [actions]
    # hide cursor after 1 second inactivity
    set_cursor_auto_hide(1)
    # maintain window size
    toggle_scale_mode(5)
    ${extraActions}

    [keybindings]
    t { montage_mode_enter() }
    x { command(rm $1) }
    y { command(wl-copy $1) }
    z { toggle_scale_mode(0) }
    ? { command(>pqiv --show-bindings) }
    <Left> { goto_file_relative(-1) }
    <Right> { goto_file_relative(1) }
    <Up> { nop() }
    <Down> { nop() }
    ${extraKeybindings}

    @MONTAGE {
      t { montage_mode_return_cancel() }
    }
    ${extraConfig}
  '';
}
