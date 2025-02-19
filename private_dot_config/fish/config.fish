if status is-interactive
    # Commands to run in interactive sessions can go here
end

export PATH="~/.local/bin:$PATH"

starship init fish | source
fzf --fish | source
zoxide init fish | source
source ~/.asdf/asdf.fish

export EDITOR=nvim
export VISUAL=nvim

alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias cd="z"

# --- setup fzf theme ---
set fg "#CDD6F4"            # Text
set bg "#1E1E2E"            # Background
set bg_highlight "#313244"  # Selection background
set purple "#CBA6F7"        # Mauve
set blue "#89B4FA"          # Blue
set cyan "#94E2D5"          # Teal

# --- setup fzf options ---
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--color=fg:$fg,bg:$bg,hl:$purple,fg+:$fg,bg+:$bg_highlight,hl+:$purple,info:$blue,prompt:$cyan,pointer:$cyan,marker:$cyan,spinner:$cyan,header:$cyan --style=full --height=40% --tmux=80% --layout=reverse --border=top --preview 'bat -n --color=always --line-range :500 {}'"
set -g FZF_CTRL_T_COMMAND "command fd -L --type f --hidden --follow --exclude .git . \$dir"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Custom settings for fzf.fish
set -gx $EDITOR "nvim" # or "vim", or "code", etc.
set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set fzf_fd_opts --hidden --max-depth 2
set fzf_preview_dir_cmd eza --all --color=always --icons=always
