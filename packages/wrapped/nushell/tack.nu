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
  | fzf --multi --border horizontal --border-label "Select inputs to update."
  | lines

  print $"Selections: ($selections)"

  if ($selections | is-empty) {
    print "No selections made."
    cd $pwd
    return
  }

  let name = $selections | each {
    |e|
      print $"(ansi cyan)Input: (ansi cyan_bold)($e)(ansi reset)"

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
        print $"No update available at ($repo)."
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
          print "Source: Codeberg"

          http get $"https://codeberg.org/($repo)/compare/($old)...($new).diff"
          | save $"/tmp/codeberg-($e).diff"

          try {
            moor $"/tmp/codeberg-($e).diff"
          } catch {|err| $err}

          rm $"/tmp/codeberg-($e).diff"
        } else if ($alias | str contains 'gh') {
          print "Source: Github"

          http get $"https://github.com/($repo)/compare/($old)...($new).diff"
          | save $"/tmp/github-($e).diff"

          try {
            moor $"/tmp/github-($e).diff"
          } catch {|err| $err}

          rm $"/tmp/github-($e).diff"
        }
      }
  }
  print $"(ansi cyan_bold)Approve all changes?(ansi reset) [y/n]"

  let input =  (input --default "n")

  if ($input | str contains 'y' ) {
    # Use spread operator to pass list items as separate arguments
    tack update ...$selections
  } else {
    print "Update rejected."
  }
  cd $pwd
}
