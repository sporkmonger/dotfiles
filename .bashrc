YELLOW="\[\e[33;40m\]"
RED="\[\e[31;40m\]"
GREEN="\[\e[32;40m\]"
BLUE="\[\e[34;40m\]"
NONE="\[\e[0m\]"

export PATH=".:/usr/local/bin:/usr/local/git/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH:/usr/X11/bin:/Developer/Tools:/usr/local/pgsql/bin:/usr/local/mysql/bin"
export INCLUDE="/usr/local/include:/usr/include"
export LIBDIR="/usr/local/lib:/usr/lib"
export CFLAGS="-I/usr/local/include -L/usr/local/lib"
export LDFLAGS="-L/usr/local/lib"
export MANPATH="/usr/local/git/man:$MANPATH"
export HISTSIZE=500000
export EDITOR="subl -w"
export SYDNEY="1"
export PGDATA="/usr/local/pgsql/data"
export XAPIAN_FLUSH_THRESHOLD="1000000"
export PAK_HOME="$HOME/.pak"
export RIPDIR="$HOME/.rip"
export PATH="$PATH:$RIPDIR/active/bin"
if [ -d "$HOME/go" ] ; then
    export GOHOME=$HOME/go
elif [ -d "$HOME/Projects/Go" ] ; then
    export GOHOME="$HOME/Projects/Go"
fi
export GOPATH="$GOHOME"
export PATH=$PATH:$GOPATH/bin

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi
# set PATH so it includes Android SDK if it exists
if [ -d "$HOME/AndroidSDK/tools" ] ; then
    PATH="$HOME/AndroidSDK/tools:$PATH"
fi

# Setting PATH for JRuby 1.6.7.2
# The orginal version is saved in .profile.jrubysave
PATH="${PATH}:/Library/Frameworks/JRuby.framework/Versions/Current/bin"

# Add RVM to PATH for scripting
PATH=$PATH:$HOME/.rvm/bin

export PATH

# On OS X, use the java_home command to locate correct JAVA_HOME
if [[ -s /usr/libexec/java_home && -d $(/usr/libexec/java_home) ]] ; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi

# Detect presence of Amazon EC2 CLI tools and configure.
if [ -d /usr/local/ec2/ ] ; then
  EC2_REL_PATH=$(ls -t /usr/local/ec2/ | head -1)
  export EC2_HOME="/usr/local/ec2/${EC2_REL_PATH%/}"
  export PATH=$PATH:$EC2_HOME/bin

  # This seems like a semi-reasonable place to stick the
  # access key ID & secret. Obviously I don't want those in my
  # dotfiles. This is only needed if the CLI tools are installed.
  if [ -s ~/.ssh/amazon-ec2/setup_credentials ] ; then
    source ~/.ssh/amazon-ec2/setup_credentials
  fi
fi
if [ -d ~/.local/lib/aws/bin ]; then
  export PATH=$PATH:~/.local/lib/aws/bin
fi

if [ -s /usr/local/bin/brew ]; then
  if [ -s $(brew --prefix)/etc/bash_completion ]; then
    $(brew --prefix)/etc/bash_completion
  fi
fi

if [ -s ~/.bin/git-prompt.sh ]; then
  source ~/.bin/git-prompt.sh
else
  if [ ! -d ~/.bin/ ]; then
    mkdir -p ~/.bin/
  fi
  echo "Attempting to fetch git-prompt.sh..."
  command -v curl >/dev/null 2>&1 || { echo >&2 "I require curl but it's not installed. Aborting."; exit 1; }

  curl "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh" > ~/.bin/git-prompt.sh
  chmod +x ~/.bin/git-prompt.sh
  source ~/.bin/git-prompt.sh
fi

if [ -s ~/.bin/git-bash-completion.sh ]; then
  source ~/.bin/git-bash-completion.sh
else
  if [ ! -d ~/.bin/ ]; then
    mkdir -p ~/.bin/
  fi
  echo "Attempting to fetch git-completion.bash..."
  curl "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash" > ~/.bin/git-bash-completion.sh
  chmod +x ~/.bin/git-bash-completion.sh
  source ~/.bin/git-bash-completion.sh
fi

alias ls="ls -FG"
alias clipboard="pbcopy"
alias rubywarn="export RUBYOPT=-w"
alias ocaml="rlwrap /usr/local/bin/ocaml"
alias rirb="bundle exec rails c"

psgrep()
{
  ps aux | grep -v grep | grep "USER.*COMMAND"
  ps aux | grep -v grep | grep $1
}

# Searches all parent directories for a given file
upfind() {
  slashes=${PWD//[^\/]/}
  directory="$PWD"
  for (( n=${#slashes}; n>0; --n ))
  do
    test -e "$directory/$1" && echo "$directory/$1" && return
    directory="$directory/.."
  done
}

# Allows make to search for the nearest Makefile in all parent directories
make() {
  makecommand=$(which make)
  makefilepath=$(upfind "Makefile")
  if [[ -s $makefilepath ]]; then
    makefiledir=$(dirname $makefilepath)
    if [[ -d $makefiledir ]]; then
      $makecommand -C $makefiledir $@
    else
      $makecommand $@
    fi
  else
    $makecommand $@
  fi
}

git_dirty_flag() {
  git status 2> /dev/null | grep -c : | awk 'function red(s) { printf "\033[1;31m" s "\033[0m " }; function green(s) { printf "\033[1;32m" s "\033[0m " }; {if ($1 > 0) print red("✗"); else print green("✓");}'
}

if [ ! -n "$(type -t __git_ps1)" ] || [ ! "$(type -t __git_ps1)" = function ]; then
  if [[ $OSTYPE == 'darwin14' ]]; then
    echo "Missing __git_ps1 function, perhaps install git via homebrew?"
  fi
fi

prompt_func()
{
    prompt="${GREEN}\u@\h${NONE}:${BLUE}\w${RED}$(__git_ps1 " (%s)")${NONE} $(git_dirty_flag)"
    PS1="${prompt}\n❯ "
    history -a
    history -n
}
PROMPT_COMMAND=prompt_func

shopt -s histappend

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
