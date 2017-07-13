[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh # load NVM into a shell session as a function

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

eval "$(direnv hook bash)" # Load direnv for managing environment variables
