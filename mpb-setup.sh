# SSH stuff
mkdir -p -m 700 ~/.ssh
ssh-keygen -t ed25519 -C "<EMAIL>"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Add to keychain
cat <<'EOF' >> ~/.ssh/config
Host *
  IgnoreUnknown UseKeychain
  UseKeychain yes
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
EOF

# Upgrade macOS to latest everything
softwareupdate --all --install --force
# Install developer tools
xcode-select --install
# Upgrade macOS to latest everything again just to be sure...
softwareupdate --all --install --force

# Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# UV
curl -LsSf https://astral.sh/uv/install.sh | sh
# Zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
zinit self-update

# Installs
brew install --cask iterm2
brew install --cask quicklook-json
brew install eza
brew install jq
brew install git
brew install grep
brew install antidote
brew install zsh-defer
brew install node
brew install --cask sublime-text


git config --global user.name "<name>"
git config --global color.ui auto
git config --global pull.rebase false
git config --global fetch.prune true
git config --global push.autoSetupRemote true

# Disabling the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoiding the creation of .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Speeding up Mission Control animations and grouping windows by application
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true

# Enable App Exposé
# Swipe down with three/four fingers
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# Enable `Tap to click`
defaults write com.apple.AppleMultitouchTrackpad.plist Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Preventing Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# restart finder to apply finder things
killall Finder
# restart dock to apply dock things
killall Dock

brew install starship
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
starship preset pastel-powerline -o ~/.config/starship.toml


echo "zinit light zdharma-continuum/fast-syntax-highlighting" >> ~/.zshrc
echo "zinit light zsh-users/zsh-autosuggestions" >> ~/.zshrc
echo "zinit light marlonrichert/zsh-autocomplete" >> ~/.zshrc
echo "zinit light MichaelAquilina/zsh-you-should-use" >> ~/.zshrc
echo "zinit light zsh-users/zsh-history-substring-search" >> ~/.zshrc
# Make up/down arrows for zsh-history-substring-search work
echo "bindkey '^[[A' history-substring-search-up && bindkey '^[[B' history-substring-search-down" >> ~/.zshrc
echo "setopt interactivecomments" >> ~/.zshrc
 

# Other Alias
cat <<'EOF' >> ~/.zshrc
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
EOF


