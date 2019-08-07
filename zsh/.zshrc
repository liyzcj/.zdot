
##################################################
## This is configuration file for zsh            #
## @author Li Yanzhe, 2018.                      #
##################################################


# ================= Variable ===============
zdot=~/.zdot

# ================ Utilities ===============
# enable 256 color to make auto-suggestions look nice
export TERM="xterm-256color"

# zstyle ':completion:*:complete:-command-:*:*' ignored-patterns '*.dll|*.exe|*.so|*.pyd'
# zstyle ':completion:*:complete:-command-:*:*' ignored-patterns '*.pdf|*.exe|*.dll'
# zstyle ':completion:*:(all-|)files' ignored-patterns '*.pdf|*.exe|*.dll'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
bindkey -v                  # Use vim key bind
bindkey '^_' autosuggest-execute # key for auto suggestion plugin

# ================= ALIAS ==================
test -r $zdot/lib/ls_colors && \
	eval "$(dircolors -b $zdot/lib/ls_colors)" \
	|| eval "$(dircolors -b)"
source $zdot/zsh/.zshrc_alias
# ================ OPTION ==================
setopt NO_BEEP              # Don't beep on errors.
setopt EXTENDED_GLOB        # User #, ~ and ^ in patterns.
# WSL (aka Bash for Windows) doesn't work well with BG_NICE
# # [ -d "/mnt/c" ] && [[ "$(uname -a)" == *Microsoft* ]] && unsetopt BG_NICE
setopt NO_BG_NICE
setopt AUTO_PUSHD           # Make cd works like pushd
setopt PUSHD_IGNORE_DUPS    # Only one instance of dir on stack

# ============ History commands ============
HISTSIZE=100
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS # Never save duplicate of existing hist entry.
setopt INC_APPEND_HISTORY   # Save history as it happens


# ============ Initialize antigen ==========
# NTIGEN_MUTEX=false
source "$zdot/zsh/antigen/antigen.zsh"

# ===== Hightlighter ====
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
# Declare the variable
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[alias]='fg=012'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=012'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=141'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
ZSH_HIGHLIGHT_STYLES[path]='fg=039'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=085'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=009'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=009'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=090'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=094'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=166'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=178'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=208'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=009'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=208'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=009'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=208'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=009'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=009'
ZSH_HIGHLIGHT_STYLES[assign]='fg=099'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=160'
ZSH_HIGHLIGHT_STYLES[comment]='fg=052,bold'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=036'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=028'
ZSH_HIGHLIGHT_STYLES[default]='fg=205'



# ======= Plugins =======
# antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle ael-code/zsh-colored-man-pages
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure
#antigen bundle thewtex/tmux-mem-cpu-load

antigen apply
# ============ Finish antigen ==============

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
