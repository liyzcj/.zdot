
##################################################
## This is configuration file for zsh            #
## @author Li Yanzhe, 2018.                      #
##################################################

# ================ Utilities ===============
# enable 256 color to make auto-suggestions look nice
export TERM="xterm-256color"

# zstyle ':completion:*:complete:-command-:*:*' ignored-patterns '*.dll|*.exe|*.so|*.pyd'
# zstyle ':completion:*:complete:-command-:*:*' ignored-patterns '*.pdf|*.exe|*.dll'
# zstyle ':completion:*:(all-|)files' ignored-patterns '*.pdf|*.exe|*.dll'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
bindkey -v                  # Use vim key bind
bindkey '^_' autosuggest-execute # key for auto suggestion plugin
bindkey '^R' history-incremental-search-backward

# ================= ALIAS ==================

if [[ `uname -s` == "Darwin" ]]; then
	export CLICOLOR=1
	export LSCOLORS=gxfxcxdxbxegedabagacad
	# only for mac
	export PATH=/usr/local/bin:$PATH
else
	test -r $HOME/.ls_colors && \
		eval "$(dircolors -b $HOME/.ls_colors)" \
		|| eval "$(dircolors -b)"
fi

source $HOME/.zshrc_alias
# ================ OPTION ==================
setopt NO_BEEP              # Don't beep on errors.
setopt EXTENDED_GLOB        # User #, ~ and ^ in patterns.
# WSL (aka Bash for Windows) doesn't work well with BG_NICE
# # [ -d "/mnt/c" ] && [[ "$(uname -a)" == *Microsoft* ]] && unsetopt BG_NICE
setopt NO_BG_NICE
setopt AUTO_PUSHD           # Make cd works like pushd
setopt PUSHD_IGNORE_DUPS    # Only one instance of dir on stack

# set nomatch https://unix.stackexchange.com/questions/310540/how-to-get-rid-of-no-match-found-when-running-rm
setopt +o nomatch

# ============ History commands ============
HISTSIZE=100
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS # Never save duplicate of existing hist entry.
setopt INC_APPEND_HISTORY   # Save history as it happens


# ============ Initialize antigen ==========
# NTIGEN_MUTEX=false
source "$HOME/.antigen/antigen/antigen.zsh"

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
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle ael-code/zsh-colored-man-pages
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

antigen apply
# ============ Finish antigen ==============

# =============== Pure ================
zstyle :prompt:pure:path color 039
zstyle :prompt:pure:prompt:success color 048
zstyle :prompt:pure:git:branch color 214
zstyle :prompt:pure:git:dirty color 198
# =========== Finish Pure =============

# Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export GO111MODULE=auto
export GOPROXY=https://goproxy.cn
