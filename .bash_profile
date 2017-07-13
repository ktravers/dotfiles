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
export LSCOLORS=gxxxxxxxcxxxxxcxcxgxgx
export GREP_OPTIONS='--color=always'

# Paths
# =====================
# The USR_PATHS variable will store all relevant /usr paths for easier usage
# Each path is separated via a : and we always use absolute paths.

# A bit about the /usr directory
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

# A function to bring local ironboard repo completely up to date
# USE: cd into /ironboard first, then run command
function ibgo () {
  git pull --rebase --prune                  # pull down latest from master + prune unused branches
  git gc                                     # compress
  bundle                                     # run bundler to install/update gems
  yarn install                               # run yarn install to install/update packages
  bin/rake db:migrate RAILS_ENV=development  # run dev db migrations
  bin/rake db:migrate RAILS_ENV=test         # run test db migrations
  git checkout -- db/schema.rb               # discard db schema changes
}

# Aliases
# =====================
# LS
alias l='ls -lah'

# db
alias dbmtest='rake db:migrate RAILS_ENV=test'
alias dbmdev='rake db:migrate RAILS_ENV=development'
alias schemareload="rm db/schema.rb && rake db:migrate"
# credit: http://danielchangnyc.github.io/blog/2014/05/15/two-bash-profile-aliases/

# Git
alias gco="git checkout"
alias gcl="git clone"
alias gst="git status"
alias gd="git diff | mate"
alias gl="git pull"
alias glr="git pull --rebase"
alias gp="git push"
alias gc="git commit -v"
alias gca="git commit -v -a"
alias gcam="git commit -am"
alias gb="git branch"
alias gba="git branch -a"
alias gbb="git branch -b"
alias gbv="git branch -v"
alias gbdall="git branch | grep -v 'master' | xargs git branch -D"
alias gcm="git checkout master"
alias grm="git rebase master"

# Jekyll
alias js='jekyll serve'

# Rspec
alias rff="rspec --fail-fast"

# Sublime Text
alias subl='open -a /Applications/Sublime\ Text.app'

# Hub
eval "$(hub alias -s)"
alias hubpr="hub pull-request -o"

# Rails
alias rs='rails s'
alias rc='rails c'
alias rcs='rails c --sandbox'

# Finder - Show / Unshow Hidden Files
alias reveal='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias rehide='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# Case-Insensitive Auto Completion
# =====================
bind "set completion-ignore-case on"

# Final Configurations and Plugins
# =====================
# Git Bash Completion
# Will activate bash git completion if installed
# via homebrew
# if [ -f `brew --prefix`/etc/bash_completion ]; then
#   . `brew --prefix`/etc/bash_completion
#   GIT_PS1_SHOWDIRTYSTATE=true
#   GIT_PS1_SHOWUNTRACKEDFILES=true
# fi

source ~/.bashrc

# NVM
# Mandatory loading of NVM into the shell
# This must be the last line of your bash_profile always
export NVM_DIR="/Users/kLocal/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# RVM
# Mandatory loading of RVM into the shell
# This must be the last line of your bash_profile always
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
