{
  self,
  inputs,
  pkgs,
  ...
}: {
  services.gnome = {
    gnome-keyring.enable = true;
    gnome-online-accounts.enable = true;
  };

  hjem.users.sumelan.rum = {
    programs.hylki = {
      enable = true;
      package = inputs.hylki.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        accounts = {
          accounts = [
            {
              aliases = [];
              avatar = self + "/users/sumelan/sumelan.png";
              color = "#f4b8e4";
              email = "sumelan@kagimail.com";
              enabled = true;
              folders_seeded = true;
              goa_enabled_before_mail_disabled = true;
              goa_id = "account_1795611391_0";
              goa_mail_disabled = false;
              gravatar = false;
              imap_host = "mail.kagimail.com";
              imap_port = 993;
              name = "sumelan";
              oauth = false;
              protocol = "imap";
              security = {
                imap_accept_invalid_certs = false;
                imap_starttls = false;
                smtp_accept_invalid_certs = false;
                smtp_no_auth = false;
                smtp_starttls = false;
              };
              signature_html = false;
              smtp_host = "mail.kagimail.com";
              smtp_port = 465;
              smtp_separate = false;
              smtp_username = "sumelan@kagimail.com";
              tls_accept_hostname_mismatch = false;
              username = "sumelan@kagimail.com";
            }
          ];
        };
        privacy = {
          account_chip = true;
          account_click_folds = false;
          allowed_senders = [];
          always_show_recipients = false;
          app_theme = "system";
          ask_plain_switch = true;
          assistant = {
            accounts = {};
            address_books = false;
            enabled = false;
            mail_people = false;
          };
          attachment_drawer = true;
          auto_remote_content = false;
          autostart = false;
          avatars = true;
          blacklist = [];
          card_attachments = true;
          chevrons_left = false;
          clean_links = true;
          clock_style = "system";
          compose_default_from = "";
          compose_format = "rich";
          compose_inline = true;
          compose_plain = false;
          confirm_thread_delete = true;
          console_mode = false;
          contact_book = "hylki-local";
          contact_names = false;
          contacts_footer_default_applied = true;
          contacts_placement = "footer";
          contacts_search_open = false;
          date_groups_default_applied = true;
          date_style = "system";
          desktop_icons = true;
          discard_notice = false;
          favorites_placement = "above_accounts";
          fetch_interval_secs = 300;
          files_action = "ask";
          files_large = "ask";
          files_limit_mb = 20;
          filtered_placement = "above_accounts";
          fold_messages = "never";
          fold_quote = true;
          folder_sort = "custom";
          follow_plain = false;
          gmail_keys = false;
          gravatar = true;
          keep_downloads_days = 0;
          key_lookup = false;
          keyserver_lookup = false;
          launcher_badge = "all_unread";
          launcher_count = true;
          link_browser = "";
          list_bulk_bar_bottom = false;
          list_column_scroll = false;
          list_column_widths = {};
          list_columns = [
            "star"
            "replied"
            "sender"
            "subject"
            "tags"
            "attachment"
            "date"
          ];
          list_folded_days = {};
          list_follows_window = false;
          list_group_by_date = true;
          list_headings = false;
          list_layout = "automatic";
          list_pills_below = false;
          list_recipients = {};
          list_search_bottom = false;
          list_search_open = false;
          list_sort = "date_newest";
          list_sort_reversed = false;
          list_sorts = {};
          message_theme = "system";
          metered_save_data = true;
          notification_buttons = [
            "mark_read"
            "archive"
            "delete"
          ];
          notification_content = true;
          notifications = true;
          notify_receipts = true;
          override_colors = false;
          override_fonts = false;
          own_mailbox_face = true;
          paste_plain = true;
          pgp_labels = false;
          plain_font = "Adwaita Mono 11";
          plain_monospace = false;
          preview_lines = 1;
          previewer_pictures = false;
          print = {
            date = false;
            page_numbers = true;
            punch_margin = false;
          };
          push = true;
          rail_dots = true;
          rail_fold = {
            accounts = true;
            all_inboxes = true;
            archive = true;
            drafts = true;
            enabled = true;
            filtered = true;
            junk = true;
            sent = true;
            snoozed = true;
            starred = true;
            tags = true;
            trash = true;
          };
          read_mark = "shown";
          reader_default = "remember";
          reader_find_bottom = false;
          reader_font = "Montserrat 14";
          reader_mode = false;
          reader_switch = true;
          reader_zoom = 100;
          reading_pane = "right";
          receipts = "ask";
          remember_rail = true;
          remember_sidebar = true;
          remote_ahead = false;
          reply_fields = false;
          reply_header = "";
          reply_inline = true;
          reply_position = "top";
          reply_to_sender = false;
          request_receipts = false;
          return_paragraph = false;
          returned_receipts = "trash";
          run_in_background = true;
          section_style = "unified";
          seen_counts = false;
          sender_logos = true;
          settings_open_accounts = false;
          show_accounts = true;
          show_attachments = true;
          show_remote_banner = true;
          show_spoof_banner = true;
          show_unified = true;
          sidebar_hover_expand = false;
          signature_dashes = false;
          signature_position = "above_quote";
          single_card_default_applied = true;
          single_key_shortcuts = true;
          single_message_card = true;
          spellcheck = true;
          spellcheck_langs = "";
          start_fullscreen = false;
          start_view = "all_inboxes";
          status_bar_top = false;
          swipe_enabled = true;
          swipe_reversed = false;
          swipe_sensitivity = 3.5;
          tag_row_tint = true;
          tags_placement = "above_accounts";
          text_scale = 100;
          theme = "system";
          theme_switch_shown = true;
          thread_expansion = false;
          thread_newest_first = false;
          thread_row_newest = false;
          threading = true;
          threads_expanded = false;
          toolbar_expanded = false;
          toolbar_fold_right = true;
          tray = true;
          tray_icon = "symbolic";
          tray_mail = true;
          undo_send_secs = 5;
          unified_chip = true;
          unified_chips = {
            all_inboxes = true;
            archive = true;
            drafts = true;
            junk = true;
            snoozed = true;
            starred = true;
            trash = true;
          };
          unified_kinds = {
            archive = true;
            drafts = true;
            junk = false;
            sent = true;
            snoozed = true;
            starred = true;
            trash = false;
          };
        };
        sidebar = {
          archive_expanded = false;
          collapsed = [];
          contacts_expanded = false;
          contacts_folded = [];
          drafts_expanded = false;
          favorites = [];
          favorites_expanded = false;
          filtered_expanded = false;
          filtered_expanded_accounts = [];
          folder_order = [];
          folders_expanded = [];
          icon_only = false;
          junk_expanded = false;
          order = [];
          sent_expanded = false;
          smart_expanded = false;
          snoozed_expanded = false;
          starred_expanded = false;
          tags_expanded = false;
          tags_expanded_accounts = [];
          trash_expanded = false;
          tree_collapsed = [];
          unified_expanded = false;
        };
        sound = {
          enabled = true;
          sound = "click";
          when_focused = true;
        };
        state = {
          about_height = 740;
          app_icon = "default";
          app_icon_generation = 3;
          contacts_pane_width = 280;
          drawer_collapsed = false;
          drawer_height = 160;
          drawer_list_view = false;
          drawer_sort_desc = false;
          gallery_archive = true;
          gallery_folders = [];
          gallery_other = true;
          gallery_sort = 0;
          gallery_table_view = false;
          gallery_thumb_width = 230;
          last_account = "sumelan@kagimail.com";
          last_view = {
            email = "sumelan@kagimail.com";
            path = "INBOX";
          };
          list_pane_height = 320;
          list_pane_height_share = 0;
          list_pane_width = 350;
          list_pane_width_share = 0;
          mint_keyring_help_dismissed = false;
          split_reply_height = 0;
          wizard_completed = true;
        };
        window = {
          height = 1362;
          maximized = false;
          width = 1251;
        };
      };
    };
  };

  custom.fileSystem = {
    persist.home.directories = [
      ".local/share/co.hyprlab.Hylki"
    ];

    cache.home.directories = [
      ".cache/co.hyprlab.Hylki"
    ];
  };
}
