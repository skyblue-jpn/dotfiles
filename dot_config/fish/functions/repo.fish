# This function is a fish-version of a repository management tool using ghq and fzf.
# The original idea and implementation can be found here:
# https://zenn.dev/inovue/articles/gh-ghq-fzf-repository-management
function repo
    set -l action list
    if test (count $argv) -ge 1
        set action $argv[1]
    end

    switch $action
        case list l
            # List all repositories with fzf selection
            set -l selected_repo (ghq list | fzf --height=50% --border --preview "echo {}" --preview-window=down:3:wrap)
            if test -n "$selected_repo"
                echo "Selected: $selected_repo"
                echo "Path: "(ghq root)"/$selected_repo"
            end

        case cd c
            # Change directory to selected repository
            set -l selected_repo (ghq list | fzf --height=50% --border --preview "echo {}" --preview-window=down:3:wrap)
            if test -n "$selected_repo"
                cd (ghq root)/$selected_repo; or return 1
            end

        case remove rm r
            # Remove selected repository
            set -l selected_repo (ghq list | fzf --height=50% --border --preview "echo {}" --preview-window=down:3:wrap --prompt "Select repository to remove: ")
            if test -n "$selected_repo"
                echo "Are you sure you want to remove $selected_repo? [y/N]"
                read -l confirm
                if string match -qr '^[Yy]$' -- "$confirm"
                    rm -rf (ghq root)/$selected_repo
                    echo "Removed: $selected_repo"
                else
                    echo "Cancelled"
                end
            end

        case get g
            # Clone/get a new repository
            if test (count $argv) -lt 2
                # Interactive mode: show remote repositories via gh + fzf
                set -l selected_repo (gh repo list --limit 100 --json nameWithOwner --jq '.[].nameWithOwner' | fzf --height=50% --border --preview "gh repo view {} --json description,url,pushedAt --template '{{.description}}\n{{.url}}\nLast updated: {{.pushedAt}}'" --preview-window=down:5:wrap --prompt "Select repository to clone: ")
                if test -n "$selected_repo"
                    ghq get "github.com/$selected_repo"
                end
            else
                ghq get $argv[2]
            end

        case create new n
            # Create a new repository directory
            if test (count $argv) -lt 2
                echo "Usage: repo create <repository_path>"
                echo "Example: repo create github.com/user/new-repo"
                return 1
            end
            set -l repo_path (ghq root)/$argv[2]
            mkdir -p "$repo_path"
            cd "$repo_path"; or return 1
            git init
            echo "Created and initialized: $argv[2]"

        case open o
            # Open repository in editor (default: code)
            set -l editor code
            if test (count $argv) -ge 2
                set editor $argv[2]
            end
            set -l selected_repo (ghq list | fzf --height=50% --border --preview "echo {}" --preview-window=down:3:wrap)
            if test -n "$selected_repo"
                set -l repo_path (ghq root)/$selected_repo
                if type -q $editor
                    $editor "$repo_path"
                else
                    echo "Editor '$editor' not found. Trying fallback editors..."
                    if type -q code
                        code "$repo_path"
                    else if type -q vim
                        vim "$repo_path"
                    else if type -q nvim
                        nvim "$repo_path"
                    else
                        echo "No suitable editor found (code, vim, nvim)"
                    end
                end
            end

        case help h '*'
            echo 'Repository management with ghq and fzf

Usage: repo <command> [args]

Commands:
  list, l           List repositories with fzf selection
  cd, c             Change directory to selected repository
  remove, rm, r     Remove selected repository (with confirmation)
  get, g [url]      Clone repository (interactive if no url)
  create, new, n    Create and initialize a new repository
  open, o [editor]  Open repository in editor (default: code)
  help, h           Show this help message

Examples:
  repo                    # List repositories
  repo cd                 # Change to selected repository
  repo get                # Interactive repository selection
  repo get github.com/user/repo
  repo create github.com/user/new-repo
  repo remove             # Remove selected repository
  repo open               # Open repository in code (default)
  repo open vim           # Open repository in vim
  repo open nvim          # Open repository in neovim

Requirements: ghq, fzf, git, gh (for interactive get)'
    end
end
