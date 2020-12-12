#!/bin/bash

echo "Setting zsh as default ..."
chsh -s $(which zsh)

echo "Installing Oh-My-Zsh .."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch || {
  echo "Could not install Oh My Zsh" >/dev/stderr
  exit 1
}

echo "Installing Homebrew ..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" -s --batch || {
  echo "Could not install homebrew" >/dev/stderr
  exit 1
}
brew update
brew tap caskroom/fonts

echo "Installing sdk"
curl -s "https://get.sdkman.io" | bash

echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | bash

echo "Installing node LTS"
nvm install node lts

echo "installing zsh plugins ..."
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

echo "Installing apps .."

brew install htop \
tree \
exa \
cowsay \
bat \
clementtsang/bottom/bottom \
vim \
tldr \
jid \
prettyping \
hyperfine \
highlight \
nvim \
youtube-dl \
autojump \
httpie \
thefuck \
golang

echo "Installing cask apps .."

brew cask install firefox \
spotify \
agenda \
iterm2 \
expressvpn \
alfred \
lastpass \
the-unarchiver \
visual-studio-code \
docker \
postman \
atom \
stats \
notion \
telegram \
ticktick \
zoom \
vlc \
numi \
intellij-idea \
whatsapp \
authy \
pixel-picker \
suspicious-package \
dash \
insomnia \
kawa \
copyq \
calibre \
microsoft-office \
font-fira-code \
brave-browser

echo "Installing font"
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

echo "Copying files"
cp .aliases ~/
cp .functions ~/
cp .exports ~/
cp .zshrc ~/
cp .gitconfig ~/
cp .p10k.zsh ~/
cp -R .iterm-themes ~/

echo "Generating a ssh key"
ssh-keygen

echo "Creating screenshots folder"
mkdir -p  ~/Desktop/screenshots
defaults write com.apple.screencapture location ~/Desktop/screenshots
defaults write NSGlobalDomain AppleShowAllExtensions -bool true