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

echo "Installing Homebrew ..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Select apps to install"

while true; do
    read -p "Do you wish to install tree? [y/n]" yn
    case $yn in
        [Yy]* ) brew install tree; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you wish to install htop? [y/n]" yn
    case $yn in
        [Yy]* ) brew install htop; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done


while true; do
    read -p "Do you wish to install exa? [y/n]" yn
    case $yn in
        [Yy]* ) brew install exa; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you wish to install sdkman? [y/n]" yn
    case $yn in
        [Yy]* ) curl -s "https://get.sdkman.io" | bash; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you wish to install node? [y/n]" yn
    case $yn in
        [Yy]* ) curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash && nvm install node lts; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you want to create a ssh key now? [y/n]" yn
    case $yn in
        [Yy]* ) ssh-keygen; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

cp .aliases ~/
cp .functions ~/
cp .zshrc ~/
