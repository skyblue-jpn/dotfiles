starship init fish | source
mise activate fish | source
zoxide init fish | source
fzf --fish | source
pay-respects fish --alias | source
batman --export-env | source
eval (batpipe)

alias cd 'z'
alias ci 'zi'

abbr -a aba 'abbr -a'
abbr -a chap 'chezmoi apply'
abbr -a chad 'chezmoi add'
abbr -a chcd 'chezmoi cd'
abbr -a gcl 'git clone'
abbr -a zed 'zeditor'
abbr -a r 'radian'

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

set -Ux FZF_DEFAULT_OPTS "\
--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
--color=selected-bg:#494D64 \
--color=border:#6E738D,label:#CAD3F5"
