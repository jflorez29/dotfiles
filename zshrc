export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

plugins=(git zsh-autosuggestions fzf fast-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# fzf plugin
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#load aliases
if [ -f ~/.aliases ]; then
  . ~/.aliases
fi

# Load functions
if [ -f ~/.functions ]; then
  . ~/.functions
fi

# Load exports
if [ -f ~/.exports ]; then
  . ~/.exports
fi
