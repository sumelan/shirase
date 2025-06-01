# list all installed packages
def nix-list-system []: nothing -> list<string> {
  ^nix-store -q --references /run/current-system/sw
  | lines
  | filter { not ($in | str ends-with 'man') }
  | each { $in | str replace -r '^[^-]*-' '' }
  | sort
}

# upgrade system packages
# `nix-upgrade` or `nix-upgrade -i`
def nix-upgrade [
  flake_path: string = "/home/sumelan/projects/wolborg", # path that contains a flake.nix
  --interactive (-i) # select packages to upgrade interactively
]: nothing -> nothing {
  let working_path = $flake_path | path expand
  if not ($working_path | path exists) {
    echo "path does not exist: $working_path"
    exit 1
  }
  let pwd = $env.PWD
  cd $working_path
  if $interactive {
    let selections = nix flake metadata . --json
    | from json
    | get locks.nodes
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
    nix flake update ...$selections
  } else {
    nix flake update
  }
  cd $pwd
  nh os switch $working_path
}


def ns [
    term: string # Search target.
] {

    let info = (
        sysctl -n kernel.arch kernel.ostype
        | lines
        | {arch: ($in.0|str downcase), ostype: ($in.1|str downcase)}
    )

    nix search --json nixpkgs $term
        | from json
        | transpose package description
        | flatten
        | select package description version
        | update package {|row| $row.package | str replace $"legacyPackages.($info.arch)-($info.ostype)." ""}
}


# `nufetch` `(nufetch).packages`
def nufetch [] {
{
"kernel": $nu.os-info.kernel_version,
"nu": $env.NU_VERSION,
"packages": (ls /etc/profiles/per-user | select name | prepend [[name];["/run/current-system/sw"]] | each { insert "number" (nix path-info --recursive ($in | get name) | lines | length) | insert "size" ( nix path-info -S ($in | get name) | parse -r '\s(.*)' | get capture0.0 | into filesize) | update "name" ($in | get name | parse -r '.*/(.*)' | get capture0.0 | if $in == "sw" {"system"} else {$in}) | rename "environment"}),
"uptime": (sys host).uptime
}
}


# Define the main command with subcommands and help text
def nx [
    subcommand?: string@nx-completions  # Optional subcommand with custom completion
    --help(-h)                          # Show this help message
] {
    let sub = $subcommand

    # Show help if requested or no subcommand provided
    if $help or ($sub | is-empty) {
        print "\nNixOS management commands:"
        print "  nx config   - Edit NixOS configuration"
        print "  nx deploy   - Deploy current NixOS configuration"
        print "  nx up       - Update NixOS flake"
        print "  nx clean    - Remove old generations"
        print "  nx gc       - Run garbage collection"
        print "  nx doctor   - Run maintenance tasks\n"
        print "  nx pull     - Pull latest github version\n"
        return
    }

    match $sub {
        "config" => { nx-config }
        "deploy" => { nx-deploy }
        "up" => { nx-up }
        "clean" => { nx-clean }
        "gc" => { nx-gc }
        "doctor" => { nx-doctor }
        "pull" => { nx-pull }
        _ => { print $"Unknown subcommand: ($sub)" }
    }
}

# Completion function for nx subcommands
def nx-completions [] {
    [
        "config",  # Edit NixOS configuration
        "deploy",  # Deploy current NixOS configuration
        "up",      # Update NixOS flake
        "clean",   # Remove old generations
        "gc",      # Run garbage collection
        "doctor"   # Run maintenance tasks
        "pull"     # Pull latest github version
    ]
}

def nx-config [] {
    let original_dir = $env.PWD
    cd /home/sumelan/projects/wolborg
    hx flake.nix
    cd $original_dir
}

def nx-deploy [] {
    let current_hostname = (hostname | str trim)
    let original_dir = $env.PWD
    cd /home/sumelan/projects/wolborg
    git diff -U0 **.nix
    print "\n-> NixOS Rebuilding..."

    if (sudo nixos-rebuild switch --flake $"./#($current_hostname)" err> nixos-switch.log | complete).exit_code != 0 {
        grep --color=always error nixos-switch.log
        return 1
    }

    let gen = (nixos-rebuild list-generations | lines | find current | first)
    git commit -am $gen
    cd $original_dir
    print "\n-> NixOS rebuild completed successfully."
}

def nx-up [] {
    print "\n-> Updating nix..."
    let current_hostname = (hostname | str trim)
    sudo nix flake update --flake $"/home/sumelan/projects/wolborg"
    sudo nixos-rebuild switch --flake $"/home/sumelan/projects/wolborg#($current_hostname)"
}

def nx-clean [] {
    print "\n-> Wiping old history ..."
    sudo nix-collect-garbage -d
}

def nx-gc [] {
    print "\n-> Initiating Garbage Collection ..."
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
}

def nx-doctor [] {
    nx-up
    nx-gc
    nx-clean
}

def nx-pull [] {
    let original_dir = $env.PWD
    cd /home/sumelan/projects/wolborg
    git pull
    cd $original_dir

    }

