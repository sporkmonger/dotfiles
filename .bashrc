YELLOW="\[\e[33;40m\]"
RED="\[\e[31;40m\]"
GREEN="\[\e[32;40m\]"
BLUE="\[\e[34;40m\]"
NONE="\[\e[0m\]"

export PATH=".:$PATH:/usr/local/bin:/usr/local/git/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/Developer/Tools:/usr/local/pgsql/bin:/usr/local/mysql/bin"
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
export PAK_HOME="/Users/sporkmonger/.pak"
export RIPDIR="/Users/sporkmonger/.rip"
export PATH="$PATH:$RIPDIR/active/bin"

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

  curl "https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh" > ~/.bin/git-prompt.sh
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
  curl "https://raw.github.com/git/git/master/contrib/completion/git-completion.bash" > ~/.bin/git-bash-completion.sh
  chmod +x ~/.bin/git-bash-completion.sh
  source ~/.bin/git-bash-completion.sh
fi

alias ls="ls -FG"
alias clipboard="pbcopy"
alias rubywarn="export RUBYOPT=-w"
alias ocaml="rlwrap /usr/local/bin/ocaml"
alias rirb="bundle exec rails c"

ps_grep()
{
  ps aux | grep -v grep | grep $1
}
alias psgrep=ps_grep

git_dirty_flag() {
  git status 2> /dev/null | grep -c : | awk '{if ($1 > 0) print "⚡"}'
}

prompt_func()
{
    prompt="${GREEN}\u@\h${NONE}:${BLUE}\w${RED}$(__git_ps1 " (%s)")${NONE}$(git_dirty_flag)"
    PS1="${prompt}\n\$ "
    history -a
    history -n
}
PROMPT_COMMAND=prompt_func

shopt -s histappend

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
