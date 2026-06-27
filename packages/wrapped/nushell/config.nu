# ── Environment ──────────────────────────────────────────────────────────────

$env.config = {
    show_banner: false

    buffer_editor: "vim"

    ls: {
        use_ls_colors: true
        clickable_links: true
    }

    rm: {
        always_trash: true
    }

    table: {
        mode: heavy
        index_mode: always
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
        }
    }

    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: false
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
        external: {
            enable: true
            max_results: 50
        }
    }

    cursor_shape: {
        emacs: line
        vi_insert: line
        vi_normal: block
    }

    #color_config.shape_external: { fg: "yellow" attr: "b" }

    edit_mode: vi

    shell_integration: {
        osc2: true              # set terminal title
        osc7: true              # notify terminal of cwd
        osc9_9: false
        osc133: true            # shell prompt markers (for terminal apps)
        osc633: true
        reset_application_mode: true
    }

    render_right_prompt_on_last_line: false

    hooks: {
        pre_prompt: [{ null }]
        pre_execution: [{ null }]
    }

    keybindings: [
        {
            # currently kitty sends this for backspace, but h also works and is agreeable
            name: backspace_kill_word
            modifier: control
            keycode: char_h
            mode: [emacs, vi_insert, vi_normal]
            event: { edit: backspaceword }
        }
    ]
}

# ── Useful Custom Commands ────────────────────────────────────────────────────

# Find files by name
def ff [pattern: string] {
    ls **/*
    | where name =~ $pattern
}

# Show PATH as a list (much more readable)
def show-path [] {
    $env.PATH | each { |p| print $p }
}

# Process search shorthand
def pg [pattern: string] {
    ps | where name =~ $pattern
}

# Update packages inside pins.toml and rebuild
def tack-upgrade [
  --interactive (-i) # Select packages to update interactively
]: nothing -> nothing {
  let working_path = $env.NH_FLAKE | path expand
  if not ($working_path | path exists) {
    echo "path does not exist: $working_path"
    exit 1
  }
  let pwd = $env.PWD
  let pins = open ($env.NH_FLAKE)/.tack/pins.toml
  cd $working_path
  if $interactive {
    let selections = $pins.inputs
    | columns
    | str join "\n"
    | fzf --multi --tmux center,20%
    | lines
    # Debug: Print selections to verify
    print $"Selections: ($selections)"
    # Check if selections is empty
    if ($selections | is-empty) {
      print "No selections made."
      cd $pwd
      return
    }
    # Use spread operator to pass list items as separate arguments
    tack update ...$selections
  } else {
    tack update
  }
  cd $pwd
  nh os switch $working_path
}

# List all installed packages
def nix-list-system []: nothing -> list<string> {
  ^nix-store -q --references /run/current-system/sw
  | lines
  | where { not ($in | str ends-with 'man') }
  | each { $in | str replace -r '^[^-]*-' '' }
  | sort
}

# ── Direnv ──────────────────────────────────────────────────────────────────────

use std/config *

# Initialize the PWD hook as an empty list if it doesn't exist
$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

$env.config.hooks.env_change.PWD ++= [{||
  if (which direnv | is-empty) {
    # If direnv isn't installed, do nothing
    return
  }

  direnv export json | from json | default {} | load-env
  # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
  $env.PATH = do (env-conversions).path.from_string $env.PATH
}]

# ── Completions ────────────────────────────────────────────────────────────────

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans | from json
}

# File-path completer as a fallback for when carapace returns nothing
let file_completer = {|spans: list<string>|
    let prefix = $spans | last
    ls ($prefix ++ "*")
    | each { |entry|
        let is_dir = ($entry.type == "dir")
        {
            value: (if $is_dir { $entry.name ++ "/" } else { $entry.name })
            description: $entry.type
        }
    }
    | sort-by value
}

# Multi-completer: tries carapace first, falls back to file completion
let multi_completer = {|spans: list<string>|
    let carapace_result = do $carapace_completer $spans
    if ($carapace_result | is-not-empty) {
        $carapace_result
    } else {
        do $file_completer $spans
    }
}

$env.config.completions.external.completer = $multi_completer

