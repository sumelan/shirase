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

# List all installed packages
def nix-list-system []: nothing -> list<string> {
  ^nix-store -q --references /run/current-system/sw
  | lines
  | where { not ($in | str ends-with 'man') }
  | each { $in | str replace -r '^[^-]*-' '' }
  | sort
}

# ── Journalctl Commands ────────────────────────────────────────────────────
# View journal with hl and hide all fields except MESSAGE
def jhl [] {
  journalctl -o json -a | hl -L --hide '*' --hide '!MESSAGE'
}

# Follow Live Logs (Streaming)
def jhlf [] {
  journalctl -o json -a -f | hl -P -L --hide '*' --hide '!MESSAGE'
}

# Show only error-level messages and above.
def jhle [] {
  journalctl -o json -a -p err | hl -L --hide '*' --hide '!MESSAGE'
}

# ── MangoWM Commands ────────────────────────────────────────────────────
# List all clients appid
def mlsa [] {
  mmsg get all-clients | from json | get clients.appid
}

# List all clients title
def mlst [] {
  mmsg get all-clients | from json | get clients.title
}

# ── Tack Commands ────────────────────────────────────────────────────
# Select inputs to update interactively with diff
def tack-update-diff []: nothing -> nothing {
  let working_path = $env.NH_FLAKE | path expand

  if not ($working_path | path exists) {
    print $"Path does not exist: ($working_path)."
    exit 1
  }

  let pwd = $env.PWD
  let pins = open ($env.NH_FLAKE)/.tack/pins.toml

  cd $working_path

  let selections = $pins.inputs
  | columns
  | str join "\n"
  | fzf --multi --style full --layout reverse
  | lines

  print $"Selections: ($selections)"

  if ($selections | is-empty) {
    print "No selections made."
    cd $pwd
    return
  }

  let name = $selections | each {
    |e|
      if ($e | str contains 'nixpkgs') {
        print "Updating nixpkgs..."
        print $"(tack update $e)"
      } else {
        print $"(ansi yellow)==== Input: (ansi attr_underline)($e)(ansi reset_underline) ====(ansi reset)"

        let alias = $pins.inputs
        | get $e
        | get url
        | split row ':'
        | get 0

        let repo = $pins.inputs
        | get $e
        | get url
        | split row ':'
        | get 1

        let change = tack look $e

        if ($change | str contains 'unchanged') {
          print $"No update available on ($e)."
          print "Skipping..."
        } else {
          let old = $change
          | split row ': '
          | get 1
          | split row ' '
          | get 0

          let new = $change
          | split row ': '
          | get 1
          | split row ' '
          | get 2

          if ($alias | str contains 'cb') {
            http get $"https://codeberg.org/($repo)/compare/($old)...($new).diff"
            | save $"/tmp/($e).diff"

            try {
              cat $"/tmp/($e).diff" | comview
            } catch {|err| $err}

          } else if ($alias | str contains 'gh') {
            http get $"https://github.com/($repo)/compare/($old)...($new).diff"
            | save $"/tmp/($e).diff"

            try {
              cat $"/tmp/($e).diff" | comview
            } catch {|err| $err}
          }

        print $"(ansi teal)Approve changes? [y/n](ansi reset)"

        let input =  (input --numchar 1 --default "n")
        
        if ($input | str contains 'y' ) {
          print $"Updating ($e)..."
          print $"(tack update $e)"
        } else {
          print "Skipping..."
        }

        rm $"/tmp/($e).diff"
      }
    }
  }
  cd $pwd
}
