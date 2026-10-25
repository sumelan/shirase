_: {
  verbs = [
    {
      key = "alt-pagedown";
      internal = "page_down";
      impacted_panel = "right";
    }
    {
      key = "alt-pageup";
      internal = "page_up";
      impacted_panel = "right";
    }
    {
      invocation = "edit";
      shortcut = "e";
      key = "ctrl-e";
      apply_to = "text_file";
      external = "direnv exec . $EDITOR {file:space-separated}";
      leave_broot = false;
    }
    {
      invocation = "create {subpath}";
      execution = "$EDITOR {directory}/{subpath}";
      leave_broot = false;
    }
    {
      invocation = "terminal";
      key = "ctrl-t";
      execution = "$SHELL";
      set_working_dir = true;
      leave_broot = false;
    }
    {
      invocation = "unar";
      external = "unar {file:space-separated}";
      leave_broot = false;
      working_dir = "{root}";
    }
    {
      invocation = "drag";
      shell_command =
        # sh
        ''ripdrag --no-click --and-exit --icon-size 128 --target --all {file:space-separated} | while read filepath; do cp -nR $filepath .; done'';
      leave_broot = false;
    }
  ];
}
