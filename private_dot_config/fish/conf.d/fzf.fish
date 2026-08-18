# source fzf shell integration
fzf --fish | source

# setup fzf theme
set fg "#CDD6F4" # Text
set bg "#1E1E2E" # Background
set bg_highlight "#313244" # Selection background
set purple "#CBA6F7" # Mauve
set blue "#89B4FA" # Blue
set cyan "#94E2D5" # Teal

# setup fzf options
set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
set -gx FZF_DEFAULT_OPTS "--color=fg:$fg,bg:$bg,hl:$purple,fg+:$fg,bg+:$bg_highlight,hl+:$purple,info:$blue,prompt:$cyan,pointer:$cyan,marker:$cyan,spinner:$cyan,header:$cyan --style=full --height=40% --tmux=80% --layout=reverse --preview 'bat -n --color=always --line-range :500 {}'"
set -g FZF_CTRL_T_COMMAND "command fd -L --type f --hidden --follow --exclude .git . \$dir"
set -gx FZF_CTRL_T_OPTS "--preview 'bat -n --color=always --line-range :500 {}'"
set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200'"

# custom settings for fzf.fish
set -gx $EDITOR nvim
set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set fzf_fd_opts --hidden --max-depth 5
set fzf_preview_dir_cmd eza --all --color=always --icons=always

# configure fzf bindings, disable history (handled by atuin)
fzf_configure_bindings --history=
