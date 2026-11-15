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

# Amend `--help` with bat
def --wrapped ph [program: string, ...rest] {
    ^$program ...$rest --help | bat --plain --language=help
}

# ── Journalctl Commands ────────────────────────────────────────────────────

# View journal with hl and hide all fields except MESSAGE
def jhl [service] {
    journalctl -xeu $service -o json -a | hl -L --hide '*' --hide '!MESSAGE'
}

# Follow Live Logs (Streaming)
def jhlf [] {
    journalctl -o json -a -f | hl -P -L --hide '*' --hide '!MESSAGE'
}

# Show only error-level messages and above.
def jhle [service] {
    journalctl $service -o json -a -p err | hl -L --hide '*' --hide '!MESSAGE'
}
