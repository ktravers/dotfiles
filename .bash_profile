# KTRAVERS BASH PROFILE
# forked from Flatiron School bash profile
# https://github.com/flatiron-school/dotfiles/blob/master/bash_profile
# ======================

# Prompt
# =====================
# called in prompt to output active git branch
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# build prompt and call below
function prompt {
  export PS1='\n\e[0;30m\e[46m\t\e[0;36m \u @\h: \W\e[0;35m$(parse_git_branch)\e[0;37m\n⚡ '
    PS2='> '
    PS4='+ '
}
prompt

# Environment Variables
# =====================
# Library Paths
# These variables tell your shell where they can find certain required libraries
# so other programs can reliably call the variable name instead of a hardcoded path.

# NODE_PATH
export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

# Postgres
export PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH"

# Configurations

# GIT_MERGE_AUTO_EDIT
# This variable configures git to not require a message when you merge.
export GIT_MERGE_AUTOEDIT='no'

# Editors
# Tells your shell that when a program requires various editors, use sublime.
# The -w flag tells your shell to wait until sublime exits
export VISUAL="subl -w"
export SVN_EDITOR="subl -w"
export GIT_EDITOR="subl -w"
export EDITOR="subl -w"

#Format ls, grep
export CLICOLOR=1

# Paths
# =====================
# The USR_PATHS variable will store all relevant /usr paths for easier usage
# Each path is separated via a : and we always use absolute paths.

# The /usr directory is a convention from Linux that creates a common place to put
# files and executables that the entire system needs access too. It tries to be user
# independent, so whichever user is logged in should have permissions to the /usr directory.
# We call that /usr/local. Within /usr/local, there is a bin directory for actually
# storing the binaries (programs) that our system would want.
# Also, Homebrew adopts this convention so things installed via Homebrew get symlinked into /usr/local
export USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin"

# We build our final PATH by combining the variables defined above
# along with any previous values in the PATH variable.
export PATH="$USR_PATHS:$PATH"


# Helper Functions
# =====================

# A function to CD into the desktop from anywhere
function desktop {
  cd /Users/$USER/Desktop/$@
}

# A function to CD into my development directory from anywhere
function development {
  cd /Users/$USER/Development/$@
}

# A function to CD into my flatiron labs directory from anywhere
function flatiron {
  cd /Users/$USER/Development/Flatiron/$@
}

# A function to CD into my local ironboard directory from anywhere
function ironboard {
  cd /Users/$USER/Development/Flatiron/ironboard/$@
}

# A function to CD into my local blog directory from anywhere
function blog {
  cd /Users/$USER/Development/ktravers.github.io/$@
}

# A function to easily grep for a matching process
# USE: psg postgres
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# A function to extract correctly any archive based on extension
# USE: extract imazip.zip
#      extract imatar.tar
function extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)  tar xjf $1      ;;
      *.tar.gz)   tar xzf $1      ;;
      *.bz2)      bunzip2 $1      ;;
      *.rar)      rar x $1        ;;
      *.gz)       gunzip $1       ;;
      *.tar)      tar xf $1       ;;
      *.tbz2)     tar xjf $1      ;;
      *.tgz)      tar xzf $1      ;;
      *.zip)      unzip $1        ;;
      *.Z)        uncompress $1   ;;
      *)          echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# A function to git clone a repo, cd into the newly created directory,
# and open all the repo's files in Sublime Text 3
# USE: gcsubl git@github.com:ktravers/crowdfunding-sql-lab-ruby-007.git
# credit: Jeremy Sklarsky (http://jeremysklarsky.github.io/)
function gcsubl () {
  git clone $1;
  cd `basename $1 .git`;
  open . -a /Applications/Sublime\ Text.app;
}

# A function to bring local rails project completely up to date
# USE: cd into repo first, then run command
function railsgo () {
  git pull --rebase --prune                 # pull latest from master + prune unused branches
  git gc                                    # compress
  bundle                                    # run bundler to install/update gems
  yarn install                              # run yarn install to install/update packages
  bin/rake db:migrate RAILS_ENV=development # run dev db migrations
  bin/rake db:migrate RAILS_ENV=test        # run test db migrations
  git checkout -- db/schema.rb              # discard db schema changes
}

# A function to bring local phoenix project completely up to date
# USE: cd into repo first, then run command
function mixgo () {
  git pull --rebase --prune                 # pull latest from master + prune unused branches
  git gc                                    # compress
  mix deps.get                              # update elixir deps
  cd apps/*/assets/ && npm install && cd -  # update js deps
  mix ecto.migrate                          # run dev db migrations
  mix ecto.migrate MIX_ENV=test             # run test db migrations
}

# Checkout next commit on current branch
# Source: https://stackoverflow.com/a/23172256/3880374
function next () {
  CURRENT_BRANCH=`git for-each-ref --format='%(refname:short)' refs/heads --contains`
  NEXT_COMMIT=`git log --format=%H --reverse --ancestry-path HEAD.."$CURRENT_BRANCH" | head -1`
  git checkout "$NEXT_COMMIT"
}

# Checkout previous commit on current branch
# Source: https://stackoverflow.com/a/23172256/3880374
function prev () {
  git checkout HEAD~
}

# Magical banner
# Source: @drewprice & @notactuallypagemcconnell
function banner() {
  figlet -f banner "$1" | sed -e"s/#/:$2:/g" | sed -e"s/ /:$3:/g" | pbcopy
}

# Aliases
# =====================
# LS
alias l='ls -lah'

# db
alias dbmtest='rake db:migrate RAILS_ENV=test'
alias dbmdev='rake db:migrate RAILS_ENV=development'

# Git
alias gba="git branch -a"
alias gbv="git branch -v"
alias gbdall="git branch | grep -v 'master' | xargs git branch -D"
alias gc="git commit -v"
alias gca="git commit -v -a"
alias gcam="git commit -am"
alias gcm="git checkout master"
alias gco="git checkout"
alias gcl="git clone"
alias gd="git diff | mate"
alias gl="git pull"
alias glp="git --paginate log --pretty=format:'%C(auto)%h%Creset %s%C(auto)%d%Creset %C(magenta bold)(%cr)%Creset %C(cyan)<%aN>%Creset' -10"
alias glr="git pull --rebase --prune"
alias gp="git push"
alias grm="git rebase master"
alias gst="git status"

# Jekyll
alias js='jekyll serve'

# Rspec
alias rff="rspec --fail-fast"

# Sublime Text
alias subl='open -a /Applications/Sublime\ Text.app'

# Hub
eval "$(hub alias -s)"
alias hubpr="hub pull-request -o"
alias hubb="hub browse"
alias hubc="hub compare $(git rev-parse --abbrev-ref HEAD)"

# Rails
alias rs='rails s'
alias rc='rails c'
alias rcs='rails c --sandbox'

# Finder - Show / Unshow Hidden Files
alias reveal='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias rehide='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# cssh
# https://github.com/flatiron-labs/operations/wiki/i2cssh
alias cssh='i2cssh -c'

# Final Configurations and Plugins
# =====================

# Case-Insensitive Auto Completion
bind "set completion-ignore-case on"

# Git Bash Completion
# Will activate bash git completion if installed via homebrew
# if [ -f `brew --prefix`/etc/bash_completion ]; then
#   . `brew --prefix`/etc/bash_completion
#   GIT_PS1_SHOWDIRTYSTATE=true
#   GIT_PS1_SHOWUNTRACKEDFILES=true
# fi

# Load direnv for managing environment variables
eval "$(direnv hook bash)"

# Kiex
# Mandatory loading of kiex into the shell
test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"

# NVM
# Mandatory loading of NVM into the shell
export NVM_DIR="/Users/$USER/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# RVM
# Mandatory loading of RVM into the shell
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
