export GOPATH="$HOME/.go"
export PATH="$PATH:$HOME/.local/bin:/opt/guixpack/bin:$GOPATH/bin"
export LD_LIBRARY_PATH="HOME/.local/lib${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"

eval "$(fasd --init auto)"

[[ $- = *i* ]] && source $PEARL_PKGVARDIR/freakhill/scripts/lib/ssh_completion
[[ $- = *i* ]] && source $PEARL_PKGVARDIR/freakhill/scripts/lib/git_completion
[[ $- = *i* ]] && source $PEARL_PKGVARDIR/freakhill/scripts/lib/srsh_completion
[[ $- = *i* ]] && source $PEARL_PKGVARDIR/paoloantinori/hhighlighter/h.sh
[[ $- = *i* ]] && source $PEARL_PKGVARDIR/tests-always-included/mo/mo
[[ $- = *i* ]] && [ -f ~/.fzf.bash ] && source ~/.fzf.bash

shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync

alias ll='ls -lG --color'
alias lla='ll -a'
