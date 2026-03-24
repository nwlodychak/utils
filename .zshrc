## GLOBALS
export EDITOR='subl'

## ALIAS
alias zsh-config="subl ~/.zshrc"
alias python="python3"

# Antidote plugin manager
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load

# pyenv: PATH setup is eager (needed immediately), init is deferred
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
zsh-defer -c 'eval "$(pyenv init - zsh)"'

# fnm (Fast Node Manager)
zsh-defer -c 'eval "$(fnm env --use-on-cd --corepack-enabled --version-file-strategy=recursive)"'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && zsh-defer source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && zsh-defer source "$NVM_DIR/bash_completion"
# Created by `pipx` on 2026-03-24 14:37:47
export PATH="$PATH:/Users/NWlodychak/.local/bin"
export PATH="$VIRTUAL_ENV/bin:$PATH"

eval "$(starship init zsh)"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light marlonrichert/zsh-autocomplete
zinit light MichaelAquilina/zsh-you-should-use
zinit light zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up && bindkey '^[[B' history-substring-search-down
setopt interactivecomments

# Git management
# ------------------------------------------------------------------------------------
alias gs="git status"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit -m"
alias gd="git diff HEAD"
alias go="git push -u origin"
alias gco="git checkout"
# Pretty git log
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
# All local branches in the order of their last commit
alias gb="git for-each-ref --sort='-authordate:iso8601' --format=' %(color:green)%(authordate:iso8601)%09%(color:white)%(refname:short)' refs/heads"
alias gnuke="git reset --hard; git clean -fdx"

# UV / Poetry management
# ------------------------------------------------------------------------------------
va () {
    source .venv/bin/activate 2>/dev/null || source ../.venv/bin/activate 2>/dev/null || { echo 'no .venv found in this or parent directory'; return 1; }
    export PATH="$VIRTUAL_ENV/bin:$PATH"
}

va! () { 
    va || vc && va
}

vc () {
    uv venv --seed --python-preference managed "$@"
}

vd () { deactivate; }

uv-poetry-install () {
  uv pip install --no-deps -r <(POETRY_WARNINGS_EXPORT=false poetry export --without-hashes --with dev -f requirements.txt)
  poetry install --only-root
}

# EZA management
# ------------------------------------------------------------------------------------
alias ls="eza --icons --group-directories-first"
alias ld="eza -D --icons=always --color=always"
alias lf="eza -f --icons=always --color=always --git-ignore"
alias ll="eza --icons --group-directories-first -l -b --total-size -g -h"
alias la='eza -a --color=always --group-directories-first'
alias lt='eza -aT -L 2 --color=always --group-directories-first'
alias l.='eza -a | grep -E "^\."'
