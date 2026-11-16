# ── Tack-related Commands ──────────────────────────────────────────────

# Map tack's inputs
def pins-map [inputs: record] {
    let rows = ($inputs | transpose name spec)
    let direct = ($rows | where {|r| 'url' in ($r.spec | columns) })
    let nested = ($rows
        | where {|r| ('url' in ($r.spec | columns)) == false }
        | each {|g| $g.spec | transpose name spec | where {|r| 'url' in ($r.spec | columns) } }
        | flatten)
    $direct | append $nested | reduce -f {} {|r, acc| $acc | upsert $r.name $r.spec }
}

# Update with showing inputs' diff
def --env tack-diff [] {
    let root = (($env.NH_FLAKE? | default $env.PWD) | path expand)
    if not ($root | path exists) { error make { msg: $"not a directory: ($root)" } }
    if (which fzf | is-empty) { error make { msg: 'fzf not on PATH' } }

    let pins   = (open ($root | path join '.tack' 'pins.toml'))
    let pinmap = (pins-map $pins.inputs)
    let schemes = ($pins.shorturls? | default {})

    let expand = {|raw: string|
        mut url = $raw
        for _ in 0..8 {
            let scheme = ($url | split row ':' | first)
            if not ($scheme in ($schemes | columns)) { break }
            let rest = ($url | split row ':' | skip 1 | str join ':')
            $url = ($schemes | get $scheme | str replace '{path}' $rest)
        }
        $url
    }

    let forge = {|raw: string|
        let u = (do $expand $raw | str replace --all 'git+' '')
        let parsed = (if ($u | str contains '://') { $u | url parse | first } else { {} })
        let host = if ($u | str starts-with 'github:') { 'github.com'
            } else if ($u | str starts-with 'gitlab:') { 'gitlab.com'
            } else { $parsed.host? }
        let path = if ($u | str contains '://') {
            ($parsed.path? | default '' | str trim --char '/')
        } else {
            ($u | split row ':' | skip 1 | str join ':')
        }
        let segs = ($path | split row '/' | where {|s| $s != '' })
        if ($host == null) or (($segs | length) < 2) { null } else {
            { host: $host, owner: $segs.0, repo: $segs.1 }
        }
    }

    let picked = ($pinmap | columns | to text
        | fzf --multi --style full --layout reverse --prompt 'pin> ' --bind 'ctrl-a:select-all'
        | lines
        | where {|l| $l != '' })
    if ($picked | is-empty) { print 'nothing selected'; return }

    cd $root
    let res = (tack look ...$picked | complete)
    if $res.exit_code != 0 {
        print -e $"(ansi red)tack look failed(ansi reset)\n($res.stderr)"
        return
    }

    # "\s*" tolerates group headers / indentation in look's output
    let look = ($res.stdout | lines
        | parse --regex '^\s*(?<name>[^:\s]+):\s*(?<rest>.*)$')

    mut approved: list<string> = []
    for pin in $picked {
        let hits = ($look | where name == $pin)
        if ($hits | is-empty) {
            print $"(ansi yellow)no look line for ($pin)(ansi reset)"
            continue
        }

        let rest = ($hits | first | get rest)
        print $"(ansi green_dimmed)($pin): ($rest)(ansi reset)"

        let move = ($rest | parse --regex '^(?<old>\S+) -> (?<new>\S+)')
        if ($move | is-empty) { continue }  # unchanged / FAILED / skipped / group header

        let m = ($move | first)

        if $pin == 'nixpkgs' {  # too big to read; take it outright
            $approved = ($approved | append $pin)
            continue
        }

        let f = (try { do $forge ($pinmap | get $pin | get url) } catch { null })
        if $f == null {
            print $"(ansi yellow)no http forge for ($pin), nothing to diff(ansi reset)"
        } else {
            let url = $"https://($f.host)/($f.owner)/($f.repo)/compare/($m.old)...($m.new).diff"
            let tmp = ($nu.temp-dir | path join $"tack-($pin)-($m.old)-($m.new).diff")
            try {
                http get --raw $url | save --force $tmp
            try { cat $tmp | comview } catch {|e| print -e $"comview: ($e.msg)" }
        } catch {|e|
            print -e $"(ansi red)diff unavailable(ansi reset) ($url): ($e.msg)"
        }
        rm -f $tmp
        }

        let answer = (input $"update ($pin)? [y/N] ")
        if ($answer | str trim | str lowercase) in ['y' 'yes'] {
            $approved = ($approved | append $pin)
        }
    }

    if ($approved | is-empty) { print 'nothing approved'; return }

    print $"(ansi teal)tack update ($approved | str join ' ')(ansi reset)"
    let upd = (tack update ...$approved | complete)
    print $upd.stdout
    if $upd.exit_code != 0 { print -e $"(ansi red)tack update failed(ansi reset)\n($upd.stderr)" }
}

