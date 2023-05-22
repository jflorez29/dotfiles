#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `osx.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Removing existing dotfiles"
rm -rf ~/.aliases ~/.exports ~/.functions ~/.vim ~/.vimrc ~/.zshrc ~/.tmux ~/.tmux.conf ~/.config/nvim 2> /dev/null

echo "Setting zsh as default ..."
chsh -s $(which zsh)

echo "Installing Xcode Command Line Tools."
# Install Xcode command line tools
xcode-select --install

source $HOME/.zshrc

echo "Installing Homebrew ..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" -s --batch || {
  echo "Could not install homebrew" >/dev/stderr
  exit 1
}

source $HOME/.zshrc

brew update
brew tap homebrew/cask
brew tap homebrew/cask-fonts

echo "Installing fonts"
brew install --cask font-fira-code-nerd-font \
font-cascadia-mono \
font-iosevka-nerd-font \
font-meslo-lg-nerd-font

echo "Installing GNU utilities .."
# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum
# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed

echo "Installing apps .."

brew install htop \
ag \
tree \
exa \
cowsay \
bat \
bottom \
vim \
tldr \
jid \
jq \
go \
libpq \
hyperfine \
highlight \
nvim \
autojump \
httpie \
pyenv \
ripgrep \
git \
tmux \
kap

echo "Installing cask apps .."

brew install --cask firefox \
spotify \
iterm2 \
expressvpn \
alfred \
the-unarchiver \
visual-studio-code \
docker \
postman \
atom \
notion \
telegram \
ticktick \
zoom \
vlc \
intellij-idea \
whatsapp \
authy \
pixel-picker \
suspicious-package \
kawa \
microsoft-office \
microsoft-edge \
cleanmymac 

# Add Symlink to pg commands
ln -s /opt/homebrew/Cellar/libpq/13.3/bin/psql /usr/local/bin/psql

echo "Setting go environment"
mkdir -p $HOME/go/{bin,src,pkg}

brew cleanup

echo "Installing sdk"
curl -s "https://get.sdkman.io?rcupdate=false" | bash

echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completio

echo "Installing node LTS"
nvm install node lts

echo "Installing Oh-My-Zsh .."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch || {
  echo "Could not install Oh My Zsh" >/dev/stderr
  exit 1
}

echo "installing zsh plugins ..."
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k


echo "Symlinking files"
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/aliases ~/.aliases
ln -s ~/dotfiles/functions ~/.functions
ln -s ~/dotfiles/exports ~/.exports
ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/gitignore ~/.gitignore
ln -s ~/dotfiles/p10k.zsh ~/.p10k.zsh

echo "Setting configuration defaults"
mkdir -p  ~/Desktop/screenshots
defaults write com.apple.screencapture location ~/Desktop/screenshots
defaults write com.apple.screencapture type -string "png"
# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true
# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2

###############################################################################
# Finder                                                                      #
###############################################################################
# Show extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false
# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false


###############################################################################
# Dock                                                                      #
###############################################################################
# Set the icon size of Dock items to 48 pixels
defaults write com.apple.dock tilesize -int 48
# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true
# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1
# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0.1
# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

###############################################################################
# Activity Monitor                                                            #
###############################################################################
# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5
# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0
# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Others                                                           #
###############################################################################
# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "
# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false
# Disable key repeat
defaults write -g ApplePressAndHoldEnabled -bool false

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" "cfprefsd" "Dock" "Finder" "SystemUIServer"; do
    killall "${app}" > /dev/null 2>&1
done

echo "Generating a ssh key"
ssh-keygen
