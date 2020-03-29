# KTRAVERS ZSHRC
# https://github.com/ktravers/dotfiles/blob/master/.zshrc
# ======================

# Plugins
# =====================
plugins=(
  bundler
  capistrano
  copyfile
  docker
  dotenv
  git
  gpg-agent
  mix
  osx
  sublime
)

# Prompt
# =====================
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PROMPT='
%F{cyan}%D{%Y-%m-%d} %* %F{magenta}%n@%m: %{$reset_color%}%1d$(parse_git_branch)
🏄‍♀️ '

# Helper Functions
# =====================
# A function to CD into my development directory from anywhere
function development {
  cd /Users/$USER/Development/$@
}

# A function to CD into my local blog directory from anywhere
function blog {
  cd /Users/$USER/Development/ktravers.github.io/$@
}

# A function to bring local rails project completely up to date
# USE: cd into repo first, then run command
function railsup () {
  git checkout master                       # checkout master branch
  git pull origin master --rebase --prune   # pull latest from master + prune unused branches
  git gc                                    # compress
  bundle                                    # run bundler to install/update gems
  yarn install                              # run yarn install to install/update packages
  bin/rake db:migrate RAILS_ENV=development # run dev db migrations
  bin/rake db:migrate RAILS_ENV=test        # run test db migrations
  git checkout -- db/schema.rb              # discard db schema changes
}

# A function to bring local phoenix project completely up to date
# USE: cd into repo first, then run command
function mixup () {
  git checkout master                       # checkout master branch
  git pull origin master --rebase --prune   # pull latest from master + prune unused branches
  git gc                                    # compress
  mix deps.get                              # update elixir deps
  cd apps/*/assets/ && npm install && cd -  # update js deps
  mix ecto.migrate                          # run dev db migrations
  mix ecto.migrate MIX_ENV=test             # run test db migrations
}

# A function to easily grep for a matching process
# USE: psg postgres
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# A function to git clone a repo, cd into the newly created directory,
# and open all the repo's files in Sublime Text 3
# USE: gcsubl git@github.com:ktravers/crowdfunding-sql-lab-ruby-007.git
# credit: Jeremy Sklarsky (http://jeremysklarsky.github.io/)
function gcsubl () {
  git clone $1;
  cd `basename $1 .git`;
  subl .
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
# Git
alias gco="git checkout"
alias gbv="git branch -v"
alias gbdall="git branch | grep -v 'master' | xargs git branch -D"
alias gcm="git checkout master"
alias glr="git pull --rebase --prune && git gc"
alias stash="git stash -u"
# https://github.com/r00k/dotfiles/blob/master/zsh/aliases#L97
alias repush="git pull --rebase && git push"

# Homebrew
alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'

# GitHub CLI
# https://github.com/cli/cli
alias newpr="gh pr create -d -w"

# Rails
alias rs='rails s'
alias rc='rails c'
alias rcs='rails c --sandbox'

# Ruby
# credit: James Coglan "Building Git" https://shop.jcoglan.com/building-git/
alias inflate='ruby -r zlib -e "STDOUT.write Zlib::Inflate.inflate(STDIN.read)"'

# Environment Variables
# =====================
# Git
# https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables
export GIT_MERGE_AUTOEDIT="no"
export GIT_AUTHOR_NAME="Kate Travers"
export GIT_COMMITTER_NAME="Kate Travers"

# Editors
# Tells your shell that when a program requires various editors, use sublime.
# The -w flag tells your shell to wait until sublime exits
export VISUAL="subl -w"
export SVN_EDITOR="subl -w"
export GIT_EDITOR="subl -w"
export EDITOR="subl -w"

# Path to your oh-my-zsh installation.
export ZSH="/Users/$USER/.oh-my-zsh"

# Build PATH
# =====================
# Add current directory bin
export USR_PATHS="bin"

# Add system local
export USR_PATHS="$USR_PATHS:/usr/local"

# Add homebrew's bin and sbin
export USR_PATHS="$USR_PATHS:/usr/local/bin"
export USR_PATHS="$USR_PATHS:/usr/local/sbin"

# Add system bin
export USR_PATHS="$USR_PATHS:/usr/bin"

export PATH="$USR_PATHS:$PATH"

# Final setup
# =====================
export GPG_TTY=$(tty)

eval "$(direnv hook zsh)"

source $ZSH/oh-my-zsh.sh

. /usr/local/opt/asdf/asdf.sh

. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash
