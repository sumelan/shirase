_: {
  modal = true;
  verbs = [
    {
      invocation = "p";
      execution = ":parent";
    }
    {
      invocation = "edit";
      shortcut = "e";
      execution = "$EDITOR {file}";
    }
    {
      invocation = "create {subpath}";
      execution = "$EDITOR {directory}/{subpath}";
    }
    {
      invocation = "view";
      execution = "less {file}";
    }
    {
      invocation = "blop {name}\\.{type}";
      execution = "mkdir {parent}/{type} && ''$EDITOR {parent}/{type}/{name}.{type}";
      from_shell = true;
    }
  ];
  skin = {
    input_fg = "rgb(198, 208, 245)";
    selected_line_bg = "rgb(98, 104, 128)";
    default_fg = "rgb(198, 208, 245)";
    tree_fg = "rgb(115, 121, 148)";
    parent_fg = "rgb(133, 193, 220)";
    status_normal_bg = "rgb(41, 44, 60)";
    status_code_fg = "rgb(234, 153, 156)";
    status_code_bg = "rgb(41, 44, 60)";
    status_error_fg = "rgb(198, 208, 245)";
    status_error_bg = "rgb(231, 130, 132)";
    # permission
    perm__fg = "rgb(181, 191, 226)";
    perm_r_fg = "rgb(239, 159, 118)";
    perm_w_fg = "rgb(234, 153, 156)";
    perm_x_fg = "rgb(166, 209, 137)";
    owner_fg = "rgb(129, 200, 190)";
    group_fg = "rgb(153, 209, 219)";
    # date
    dates_fg = "rgb(181, 191, 226)";
    # directory
    directory_fg = "rgb(186, 187, 241)";
    exe_fg = "rgb(166, 209, 137)";
    link_fg = "rgb(229, 200, 144)";
    pruning_fg = "rgb(165, 173, 206)";
  };
}
