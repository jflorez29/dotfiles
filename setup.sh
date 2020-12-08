#!/bin/bash

echo "Installing Oh-My-Zsh .."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Setting zsh as default ..."
chsh -s $(which zsh)

echo "installing zsh plugins ..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.oh-my-zsh/fzf
~/.oh-my-zsh/fzf/install
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

echo "Installing Homebrew ..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing apps .."

brew install htop \
tree \
exa \
cowsay \
bat \

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
font-fira-code

echo "Installing font"
brew tap homebrew/cask-fonts
brew cask install font-hack-nerd-font

echo "Installing sdk"
curl -s "https://get.sdkman.io" | bash

echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | bash

echo "Installing node LTS"
nvm install node lts

echo "Copying files"
cp .aliases ~/
cp .functions ~/
cp .zshrc ~/
cp .gitconfig ~/
cp .p10k.zsh

echo "Generating a ssh key"
ssh-keygen

echo "Creating screenshots folder"
mkdir -p  ~/Desktop/screenshots
defaults write com.apple.screencapture location ~/Desktop/screenshots