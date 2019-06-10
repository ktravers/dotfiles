# KTRAVERS ZSHRC
# forked from Flatiron School bash profile
# https://github.com/flatiron-school/dotfiles/blob/master/.zshrc
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
	jira
	mix
	osx
	sublime
)

# Prompt
# =====================

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
# ZSH_THEME_GIT_PROMPT_SUFFIX="]$reset_color"
# ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]+"
# ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"

PROMPT='
%F{cyan}%* %F{magenta}%n@%m: %{$reset_color%}%1d$(parse_git_branch)
⚡ '

# Helper Functions
# =====================

# A function to CD into my development directory from anywhere
function development {
  cd /Users/$USER/Development/$@
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
alias glr="git pull --rebase --prune"

# Homebrew
alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'

# Hub
alias hubpr="hub pull-request -o"

# Rails
alias rs='rails s'
alias rc='rails c'
alias rcs='rails c --sandbox'

# Environment Variables
# =====================

# Git merge autoedit
# This variable configures git to not require a message when you merge.
export GIT_MERGE_AUTOEDIT='no'

# Editors
# Tells your shell that when a program requires various editors, use sublime.
# The -w flag tells your shell to wait until sublime exits
export VISUAL="subl -w"
export SVN_EDITOR="subl -w"
export GIT_EDITOR="subl -w"
export EDITOR="subl -w"

# Path to your oh-my-zsh installation.
export ZSH="/Users/$USER/.oh-my-zsh"
# Set name of the theme to load
# ZSH_THEME="robbyrussell"

# recommended by brew doctor
export PATH="/usr/local/bin:$PATH"

export PATH="$HOME/.bin:~/bin:$PATH"

export GPG_TTY=$(tty)

eval export
eval "$(direnv hook bash)" # Load direnv for managing environment variables
eval "$(hub alias -s)"
eval "$(rbenv init -)"

source $ZSH/oh-my-zsh.sh
