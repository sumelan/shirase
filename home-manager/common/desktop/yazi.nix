{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
in {
  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        ripdrag # Drag and Drop utilty written in Rust and GTK4
        unar
        exiftool
        ;
    };

    shellAliases = {
      lf = "yazi";
      y = "yazi";
    };
  };

  programs = {
    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;

      theme = {
        mgr = {
          cwd = {fg = "#7fbbb3";};
          hovered = {reversed = true;};
          preview_hovered = {underline = true;};
          find_keyword = {
            fg = "#dbbc7f";
            bold = true;
            italic = true;
            underline = true;
          };
          find_position = {
            fg = "#d699b6";
            bg = "reset";
            bold = true;
            italic = true;
          };
          symlink_target = {italic = true;};
          marker_copied = {
            fg = "#a7c080";
            bg = "#a7c080";
          };
          marker_cut = {
            fg = "#e67e80";
            bg = "#e67e80";
          };
          marker_marked = {
            fg = "#7fbbb3";
            bg = "#7fbbb3";
          };
          marker_selected = {
            fg = "#dbbc7f";
            bg = "#dbbc7f";
          };
          count_copied = {
            fg = "#343f44";
            bg = "#a7c080";
          };
          count_cut = {
            fg = "#343f44";
            bg = "#e67e80";
          };
          count_selected = {
            fg = "#343f44";
            bg = "#dbbc7f";
          };
          border_symbol = "│";
          border_style = {fg = "#4f585e";};
          syntect_theme = "";
        };

        tabs = {
          active = {
            bg = "#7fbbb3";
            bold = true;
          };
          inactive = {
            fg = "#7fbbb3";
            bg = "#4f585e";
          };
          sep_inner = {
            open = "";
            close = "";
          };
          sep_outer = {
            open = "";
            close = "";
          };
        };

        mode = {
          normal_main = {
            fg = "#3d484d";
            bg = "#a7c080";
            bold = true;
          };
          normal_alt = {
            fg = "#7fbbb3";
            bg = "#4f585e";
            bold = true;
          };
          select_main = {
            fg = "#3d484d";
            bg = "#e67e80";
            bold = true;
          };
          select_alt = {
            fg = "#7fbbb3";
            bg = "#4f585e";
            bold = true;
          };
          unset_main = {
            fg = "#3d484d";
            bg = "#7fbbb3";
            bold = true;
          };
          unset_alt = {
            fg = "#7fbbb3";
            bg = "#4f585e";
            bold = true;
          };
        };

        status = {
          overall = {};
          sep_left = {
            open = "";
            close = "";
          };
          sep_right = {
            open = "";
            close = "";
          };
          permissions_s = {fg = "#2d353b";};
          permissions_t = {fg = "#a7c080";};
          permissions_r = {fg = "#dbbc7f";};
          permissions_w = {fg = "#e67e80";};
          permissions_x = {fg = "#7fbbb3";};
          progress_label = {bold = true;};
          progress_normal = {
            fg = "#7fbbb3";
            bg = "#232a2e";
          };
          progress_error = {
            fg = "#e67e80";
            bg = "#232a2e";
          };
        };

        which = {
          cols = 3;
          mask = {bg = "#2d353b";};
          cand = {fg = "#7fbbb3";};
          rest = {fg = "#2d353b";};
          desc = {fg = "#d699b6";};
          separator = "  ";
          separator_style = {fg = "#2d353b";};
        };

        confirm = {
          border = {fg = "#7fbbb3";};
          title = {fg = "#7fbbb3";};
          body = {};
          list = {};
          btn_yes = {reversed = true;};
          btn_no = {};
          btn_labels = ["  [Y]es  " "  (N)o  "];
        };

        spot = {
          border = {fg = "#7fbbb3";};
          title = {fg = "#7fbbb3";};
          tbl_col = {fg = "#7fbbb3";};
          tbl_cell = {
            fg = "#dbbc7f";
            reversed = true;
          };
        };

        notify = {
          title_info = {fg = "#a7c080";};
          title_warn = {fg = "#dbbc7f";};
          title_error = {fg = "#e67e80";};
          icon_info = "";
          icon_warn = "";
          icon_error = "";
        };

        pick = {
          border = {fg = "#7fbbb3";};
          active = {
            fg = "#d699b6";
            bold = true;
          };
          inactive = {};
        };

        input = {
          border = {fg = "#7fbbb3";};
          title = {};
          value = {};
          selected = {reversed = true;};
        };

        cmp = {
          border = {fg = "#7fbbb3";};
          active = {reversed = true;};
          inactive = {};
          icon_file = "";
          icon_folder = "";
          icon_command = "";
        };

        tasks = {
          border = {fg = "#7fbbb3";};
          title = {};
          hovered = {
            fg = "#d699b6";
            underline = true;
          };
        };

        help = {
          on = {fg = "#7fbbb3";};
          run = {fg = "#d699b6";};
          desc = {};
          hovered = {
            reversed = true;
            bold = true;
          };
          footer = {
            fg = "#2d353b";
            bg = "#d3c6aa";
          };
        };

        filetype = {
          rules = [
            # Images
            {
              mime = "image/*";
              fg = "#7fbbb3";
            }
            # Media
            {
              mime = "{audio,video}/*";
              fg = "#d699b6";
            }
            # Archives
            {
              mime = "application/*zip";
              fg = "#e67e80";
            }
            {
              mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}";
              fg = "#e67e80";
            }
            # Documents
            {
              mime = "application/{pdf,doc,rtf,vnd.*}";
              fg = "#7fbbb3";
            }
            # Fallback
            {
              name = "*";
              fg = "#83c092";
            }
            {
              name = "*/";
              fg = "#a7c080";
            }
          ];
        };
      };

      plugins = {
        chmod = "${pkgs.custom.yazi-plugins.src}/chmod.yazi";
        full-border = "${pkgs.custom.yazi-plugins.src}/full-border.yazi";
        git = "${pkgs.custom.yazi-plugins.src}/git.yazi";
        toggle-pane = "${pkgs.custom.yazi-plugins.src}/toggle-pane.yazi";
        mount = "${pkgs.custom.yazi-plugins.src}/mount.yazi";
        starship = "${pkgs.custom.yazi-starship.src}";
      };

      initLua =
        #lua
        ''
          require("full-border"):setup({ type = ui.Border.ROUNDED })
          require("git"):setup()
          require("starship"):setup({
            -- Custom starship configuration file to use
            config_file = "~/.config/starship.toml",
          })
        '';

      settings = {
        log.enabled = true;
        mgr = {
          ratio = [0 1 1];
          sort_by = "alphabetical";
          sort_sensitive = false;
          sort_reverse = false;
          linemode = "size";
          show_hidden = true;
        };
        opener = {};
        # settings for plugins
        plugin = {
          prepend_fetchers = [
            {
              id = "git";
              name = "*";
              run = "git";
            }
            {
              id = "git";
              name = "*/";
              run = "git";
            }
          ];
        };
      };
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "M";
            run = "plugin mount";
            desc = "Open mount";
          }
          {
            on = "T";
            run = "plugin toggle-pane max-preview";
            desc = "Maximize or restore the preview pane";
          }
          {
            on = ["c" "m"];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }
          {
            on = "<C-n>";
            run = "shell --confirm 'ripdrag \"$@\" -x 2>/dev/null &'";
          }
        ];
      };
    };

    niri.settings = {
      binds = {
        "Mod+Shift+O" = {
          action.spawn = ["${getExe pkgs.foot}" "--app-id=yazi" "yazi"];
          hotkey-overlay.title = ''<span foreground="#f1fc79">[Terminal]</span> Yazi'';
        };
      };
    };
  };
}
